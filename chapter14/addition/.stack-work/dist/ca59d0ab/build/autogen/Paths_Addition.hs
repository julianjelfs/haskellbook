{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_Addition (
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

bindir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter14\\addition\\.stack-work\\install\\e580970b\\bin"
libdir     = "C:\\Users\\julianj\\projects\\haskellbook\\chapter14\\addition\\.stack-work\\install\\e580970b\\lib\\x86_64-windows-ghc-8.0.2\\Addition-0.1.0.0-8fKgBuWqWSS4ujHF8wKnlL"
dynlibdir  = "C:\\Users\\julianj\\projects\\haskellbook\\chapter14\\addition\\.stack-work\\install\\e580970b\\lib\\x86_64-windows-ghc-8.0.2"
datadir    = "C:\\Users\\julianj\\projects\\haskellbook\\chapter14\\addition\\.stack-work\\install\\e580970b\\share\\x86_64-windows-ghc-8.0.2\\Addition-0.1.0.0"
libexecdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter14\\addition\\.stack-work\\install\\e580970b\\libexec"
sysconfdir = "C:\\Users\\julianj\\projects\\haskellbook\\chapter14\\addition\\.stack-work\\install\\e580970b\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Addition_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Addition_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Addition_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Addition_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Addition_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Addition_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
