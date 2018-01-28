{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_chapter22 (
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

bindir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter22\\.stack-work\\install\\dec5189f\\bin"
libdir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter22\\.stack-work\\install\\dec5189f\\lib\\x86_64-windows-ghc-8.2.2\\chapter22-0.1.0.0-FMYiBrhVu1S6ov4Ah1srLG"
dynlibdir  = "C:\\Users\\julianj\\projects\\haskellbook\\chapter22\\.stack-work\\install\\dec5189f\\lib\\x86_64-windows-ghc-8.2.2"
datadir    = "C:\\Users\\julianj\\projects\\haskellbook\\chapter22\\.stack-work\\install\\dec5189f\\share\\x86_64-windows-ghc-8.2.2\\chapter22-0.1.0.0"
libexecdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter22\\.stack-work\\install\\dec5189f\\libexec\\x86_64-windows-ghc-8.2.2\\chapter22-0.1.0.0"
sysconfdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter22\\.stack-work\\install\\dec5189f\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "chapter22_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "chapter22_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "chapter22_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "chapter22_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "chapter22_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "chapter22_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
