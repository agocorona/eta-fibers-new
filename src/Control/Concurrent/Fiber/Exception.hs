module Control.Concurrent.Fiber.Exception
where

import Control.Concurrent.Fiber
import Control.Monad.IO.Class (liftIO)
import qualified Control.Exception as E

-- FIX ME
mask f = f id

-- HACK ATTENTION: add 'yield' before f so that outer continuation is stopped
catch :: E.Exception e => Fiber a -> (e -> Fiber a) -> Fiber a
catch f g = callCC $ \k -> liftIO $ runFiber (yield >> f)  `E.catch` (\e -> runFiber (g e >>= k))

onException :: Fiber a -> Fiber b -> Fiber a
onException io what = io `catch` \e -> do _ <- what
                                          liftIO $ E.throwIO (e :: E.SomeException)

bracket :: Fiber a         -- ^ computation to run first (\"acquire resource\")
        -> (a -> Fiber b)  -- ^ computation to run last (\"release resource\")
        -> (a -> Fiber c)  -- ^ computation to run in-between
        -> Fiber c         -- returns the value from the in-between computation
bracket before after thing =
  mask $ \restore -> do
    a <- before
    r <- restore (thing a) `onException` after a
    _ <- after a
    return r

finally :: Fiber a         -- ^ computation to run first
        -> Fiber b         -- ^ computation to run afterward (even if an exception
                           -- was raised)
        -> Fiber a         -- returns the value from the first computation
a `finally` sequel =
  mask $ \restore -> do
    r <- restore a `onException` sequel
    _ <- sequel
    return r

try :: E.Exception e => Fiber a -> Fiber (Either e a)
try a = catch (a >>= \ v -> return (Right v)) (\e -> return (Left e))
