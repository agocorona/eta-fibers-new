{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_eta_fibers_new (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/root/.etlas/bin"
libdir     = "/root/.etlas/lib/eta-0.8.4.1/eta-fibers-new-0.1.0.0-5lNbpAue491QlM1M7aqXZ"
dynlibdir  = "/root/.etlas/lib/eta-0.8.4.1"
datadir    = "/root/.etlas/share/eta-0.8.4.1/eta-fibers-new-0.1.0.0"
libexecdir = "/root/.etlas/libexec"
sysconfdir = "/root/.etlas/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "eta_fibers_new_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "eta_fibers_new_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "eta_fibers_new_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "eta_fibers_new_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "eta_fibers_new_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "eta_fibers_new_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
