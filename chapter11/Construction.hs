module Construction where

data GuessWhat =
  Chickenbutt
  deriving (Eq, Show)

data Id a =
  MkId a
  deriving (Eq, Show)

data Product a b =
  Product a
          b
  deriving (Eq, Show)

data Sum a b
  = First a
  | Second b
  deriving (Eq, Show)

data RecordProduct a b = RecordProduct
  { pfirst  :: a
  , psecond :: b
  } deriving (Eq, Show)

newtype NumCow =
  NumCow Int
  deriving (Eq, Show)

newtype NumPig =
  NumPig Int
  deriving (Eq, Show)

data Farmhouse =
  Farmhouse NumCow
            NumPig
  deriving (Eq, Show)

type Farmhouse2 = Product NumCow NumPig

data OperatingSystem
  = GnuPlusLinux
  | OpenBSD
  | Mac
  | Windows
  deriving (Eq, Show)

data ProgrammingLanguage
  = Haskell
  | Agda
  | Idris
  | Purescript
  deriving (Eq, Show)

data Programmer = Programmer
  { os   :: OperatingSystem
  , lang :: ProgrammingLanguage
  } deriving (Eq, Show)

-- cardinality of Programmer = 4 * 4 = 16
allProgrammers :: [Programmer]
allProgrammers =
  [ Programmer os lang
  | os <- [GnuPlusLinux, OpenBSD, Mac, Windows]
  , lang <- [Haskell, Agda, Idris, Purescript]
  ]
