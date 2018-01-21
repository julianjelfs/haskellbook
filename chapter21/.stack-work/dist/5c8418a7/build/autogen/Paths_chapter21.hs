{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_chapter21 (
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

bindir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter21\\.stack-work\\install\\ccbce92a\\bin"
libdir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter21\\.stack-work\\install\\ccbce92a\\lib\\x86_64-windows-ghc-8.2.2\\chapter21-0.1.0.0-BohZ4R54GlK49xNrQ4U3It"
dynlibdir  = "C:\\Users\\julianj\\projects\\haskellbook\\chapter21\\.stack-work\\install\\ccbce92a\\lib\\x86_64-windows-ghc-8.2.2"
datadir    = "C:\\Users\\julianj\\projects\\haskellbook\\chapter21\\.stack-work\\install\\ccbce92a\\share\\x86_64-windows-ghc-8.2.2\\chapter21-0.1.0.0"
libexecdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter21\\.stack-work\\install\\ccbce92a\\libexec\\x86_64-windows-ghc-8.2.2\\chapter21-0.1.0.0"
sysconfdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter21\\.stack-work\\install\\ccbce92a\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "chapter21_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "chapter21_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "chapter21_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "chapter21_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "chapter21_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "chapter21_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
