{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_chapter23 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/jelfs/projects/haskellbook/chapter23/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/bin"
libdir     = "/home/jelfs/projects/haskellbook/chapter23/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/lib/x86_64-linux-ghc-8.2.2/chapter23-0.1.0.0-Ku7KuTDv3xUDIXLTFTo7YW"
dynlibdir  = "/home/jelfs/projects/haskellbook/chapter23/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/lib/x86_64-linux-ghc-8.2.2"
datadir    = "/home/jelfs/projects/haskellbook/chapter23/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/share/x86_64-linux-ghc-8.2.2/chapter23-0.1.0.0"
libexecdir = "/home/jelfs/projects/haskellbook/chapter23/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/libexec/x86_64-linux-ghc-8.2.2/chapter23-0.1.0.0"
sysconfdir = "/home/jelfs/projects/haskellbook/chapter23/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "chapter23_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "chapter23_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "chapter23_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "chapter23_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "chapter23_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "chapter23_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
