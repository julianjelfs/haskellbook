{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_chapter24 (
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

bindir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter24\\.stack-work\\install\\c1f464f3\\bin"
libdir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter24\\.stack-work\\install\\c1f464f3\\lib\\x86_64-windows-ghc-8.2.2\\chapter24-0.1.0.0-8rHXfyvmyUZDrBjTejGFpb"
dynlibdir  = "C:\\Users\\julianj\\projects\\haskellbook\\chapter24\\.stack-work\\install\\c1f464f3\\lib\\x86_64-windows-ghc-8.2.2"
datadir    = "C:\\Users\\julianj\\projects\\haskellbook\\chapter24\\.stack-work\\install\\c1f464f3\\share\\x86_64-windows-ghc-8.2.2\\chapter24-0.1.0.0"
libexecdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter24\\.stack-work\\install\\c1f464f3\\libexec\\x86_64-windows-ghc-8.2.2\\chapter24-0.1.0.0"
sysconfdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter24\\.stack-work\\install\\c1f464f3\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "chapter24_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "chapter24_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "chapter24_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "chapter24_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "chapter24_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "chapter24_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
