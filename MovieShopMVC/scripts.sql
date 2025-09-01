IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
CREATE TABLE [Genres] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY ([Id])
);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827023539_InitialMigration', N'9.0.8');

ALTER TABLE [Genres] DROP CONSTRAINT [PK_Genres];

EXEC sp_rename N'[Genres]', N'Genre', 'OBJECT';

DECLARE @var sysname;
SELECT @var = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Genre]') AND [c].[name] = N'Name');
IF @var IS NOT NULL EXEC(N'ALTER TABLE [Genre] DROP CONSTRAINT [' + @var + '];');
ALTER TABLE [Genre] ALTER COLUMN [Name] nvarchar(64) NULL;

ALTER TABLE [Genre] ADD CONSTRAINT [PK_Genre] PRIMARY KEY ([Id]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827030459_ChangeMigration', N'9.0.8');

CREATE TABLE [Movies] (
    [Id] int NOT NULL IDENTITY,
    [BackdropUrl] nvarchar(max) NULL,
    [Budget] decimal(18,2) NOT NULL,
    [CreatedBy] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [ImdbURL] nvarchar(max) NULL,
    [OriginalLanguage] nvarchar(max) NULL,
    [Overview] varchar(512) NULL,
    [PosterUrl] nvarchar(max) NULL,
    [Price] decimal(18,2) NOT NULL,
    [ReleaseDate] datetime2 NOT NULL,
    [Revenue] decimal(18,2) NOT NULL,
    [RunTime] int NOT NULL,
    [Tagline] nvarchar(max) NULL,
    [Title] varchar(500) NULL,
    [TmdbUrl] nvarchar(max) NULL,
    [UpdatedBy] nvarchar(max) NULL,
    [UpdatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_Movies] PRIMARY KEY ([Id])
);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827043158_CreateMovieTableMigration', N'9.0.8');

CREATE TABLE [Trailer] (
    [Id] int NOT NULL IDENTITY,
    [MovieId] int NOT NULL,
    [Name] nvarchar(256) NULL,
    [TrailerUrl] nvarchar(256) NULL,
    CONSTRAINT [PK_Trailer] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Trailer_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_Trailer_MovieId] ON [Trailer] ([MovieId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827145726_CreateTrailerTableMigration', N'9.0.8');

CREATE TABLE [MovieGenres] (
    [MovieId] int NOT NULL,
    [GenreId] int NOT NULL,
    CONSTRAINT [PK_MovieGenres] PRIMARY KEY ([MovieId], [GenreId]),
    CONSTRAINT [FK_MovieGenres_Genre_GenreId] FOREIGN KEY ([GenreId]) REFERENCES [Genre] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_MovieGenres_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_MovieGenres_GenreId] ON [MovieGenres] ([GenreId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827152447_CreateMovieGenreTableMigration', N'9.0.8');

CREATE TABLE [Cast] (
    [Id] int NOT NULL IDENTITY,
    [Gender] nvarchar(max) NOT NULL,
    [Name] nvarchar(128) NOT NULL,
    [ProfilePath] nvarchar(2084) NOT NULL,
    [TmbdUrl] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Cast] PRIMARY KEY ([Id])
);

CREATE TABLE [MovieCasts] (
    [CastId] int NOT NULL,
    [MovieId] int NOT NULL,
    [Character] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_MovieCasts] PRIMARY KEY ([MovieId], [CastId]),
    CONSTRAINT [FK_MovieCasts_Cast_CastId] FOREIGN KEY ([CastId]) REFERENCES [Cast] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_MovieCasts_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_MovieCasts_CastId] ON [MovieCasts] ([CastId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827154229_CreateCastTableMigration', N'9.0.8');

ALTER TABLE [MovieCasts] DROP CONSTRAINT [PK_MovieCasts];

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[MovieCasts]') AND [c].[name] = N'Character');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [MovieCasts] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [MovieCasts] ALTER COLUMN [Character] nvarchar(450) NOT NULL;

ALTER TABLE [MovieCasts] ADD CONSTRAINT [PK_MovieCasts] PRIMARY KEY ([MovieId], [CastId], [Character]);

CREATE TABLE [Users] (
    [Id] int NOT NULL IDENTITY,
    [DateOfBirth] datetime2 NOT NULL,
    [Email] nvarchar(256) NOT NULL,
    [FirstName] nvarchar(128) NOT NULL,
    [HashedPassword] nvarchar(1024) NOT NULL,
    [isLocked] tinyint NOT NULL,
    [LastName] nvarchar(128) NOT NULL,
    [PhoneNumber] nvarchar(16) NOT NULL,
    [ProfilePictureUrl] nvarchar(max) NOT NULL,
    [Salt] nvarchar(1024) NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY ([Id])
);

CREATE TABLE [Reviews] (
    [MovieId] int NOT NULL,
    [UserId] int NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [Rating] decimal(18,2) NOT NULL,
    CONSTRAINT [PK_Reviews] PRIMARY KEY ([MovieId], [UserId]),
    CONSTRAINT [FK_Reviews_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Reviews_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_Reviews_UserId] ON [Reviews] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827161311_CreateUserTableMigration', N'9.0.8');

ALTER TABLE [Reviews] DROP CONSTRAINT [FK_Reviews_Movies_MovieId];

ALTER TABLE [Reviews] DROP CONSTRAINT [FK_Reviews_Users_UserId];

ALTER TABLE [Reviews] DROP CONSTRAINT [PK_Reviews];

EXEC sp_rename N'[Reviews]', N'Review', 'OBJECT';

EXEC sp_rename N'[Review].[IX_Reviews_UserId]', N'IX_Review_UserId', 'INDEX';

ALTER TABLE [Review] ADD CONSTRAINT [PK_Review] PRIMARY KEY ([MovieId], [UserId]);

CREATE TABLE [Favourite] (
    [MovieId] int NOT NULL,
    [UserId] int NOT NULL,
    CONSTRAINT [PK_Favourite] PRIMARY KEY ([MovieId], [UserId]),
    CONSTRAINT [FK_Favourite_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Favourite_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_Favourite_UserId] ON [Favourite] ([UserId]);

ALTER TABLE [Review] ADD CONSTRAINT [FK_Review_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Review] ADD CONSTRAINT [FK_Review_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827162808_CreateFavouriteTableMigration', N'9.0.8');

ALTER TABLE [Favourite] DROP CONSTRAINT [FK_Favourite_Movies_MovieId];

ALTER TABLE [Favourite] DROP CONSTRAINT [FK_Favourite_Users_UserId];

ALTER TABLE [Review] DROP CONSTRAINT [FK_Review_Movies_MovieId];

ALTER TABLE [Review] DROP CONSTRAINT [FK_Review_Users_UserId];

ALTER TABLE [Review] DROP CONSTRAINT [PK_Review];

ALTER TABLE [Favourite] DROP CONSTRAINT [PK_Favourite];

EXEC sp_rename N'[Review]', N'Reviews', 'OBJECT';

EXEC sp_rename N'[Favourite]', N'Favourites', 'OBJECT';

EXEC sp_rename N'[Reviews].[IX_Review_UserId]', N'IX_Reviews_UserId', 'INDEX';

EXEC sp_rename N'[Favourites].[IX_Favourite_UserId]', N'IX_Favourites_UserId', 'INDEX';

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'isLocked');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [Users] ALTER COLUMN [isLocked] bit NOT NULL;

ALTER TABLE [Reviews] ADD CONSTRAINT [PK_Reviews] PRIMARY KEY ([MovieId], [UserId]);

ALTER TABLE [Favourites] ADD CONSTRAINT [PK_Favourites] PRIMARY KEY ([MovieId], [UserId]);

CREATE TABLE [Purchases] (
    [MovieId] int NOT NULL,
    [UserId] int NOT NULL,
    [PurchaseDateTime] datetime2 NOT NULL,
    [PurchaseNumber] uniqueidentifier NOT NULL,
    [TotalPrice] decimal(18,2) NOT NULL,
    CONSTRAINT [PK_Purchases] PRIMARY KEY ([MovieId], [UserId]),
    CONSTRAINT [FK_Purchases_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Purchases_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_Purchases_UserId] ON [Purchases] ([UserId]);

ALTER TABLE [Favourites] ADD CONSTRAINT [FK_Favourites_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Favourites] ADD CONSTRAINT [FK_Favourites_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Reviews] ADD CONSTRAINT [FK_Reviews_Movies_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [Movies] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Reviews] ADD CONSTRAINT [FK_Reviews_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827164637_CreatePurchaseTable', N'9.0.8');

CREATE TABLE [Roles] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(20) NOT NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY ([Id])
);

CREATE TABLE [UserRoles] (
    [RoleId] int NOT NULL,
    [UserId] int NOT NULL,
    CONSTRAINT [PK_UserRoles] PRIMARY KEY ([RoleId], [UserId]),
    CONSTRAINT [FK_UserRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserRoles_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_UserRoles_UserId] ON [UserRoles] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827170150_CreateUserRoleTableMigration', N'9.0.8');

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'isLocked');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [Users] ALTER COLUMN [isLocked] bit NULL;

DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'Salt');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [Users] ALTER COLUMN [Salt] nvarchar(1024) NULL;

DECLARE @var5 sysname;
SELECT @var5 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'ProfilePictureUrl');
IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var5 + '];');
ALTER TABLE [Users] ALTER COLUMN [ProfilePictureUrl] nvarchar(max) NULL;

DECLARE @var6 sysname;
SELECT @var6 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'PhoneNumber');
IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var6 + '];');
ALTER TABLE [Users] ALTER COLUMN [PhoneNumber] nvarchar(16) NULL;

DECLARE @var7 sysname;
SELECT @var7 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'LastName');
IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var7 + '];');
ALTER TABLE [Users] ALTER COLUMN [LastName] nvarchar(128) NULL;

DECLARE @var8 sysname;
SELECT @var8 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'HashedPassword');
IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var8 + '];');
ALTER TABLE [Users] ALTER COLUMN [HashedPassword] nvarchar(1024) NULL;

DECLARE @var9 sysname;
SELECT @var9 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'FirstName');
IF @var9 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var9 + '];');
ALTER TABLE [Users] ALTER COLUMN [FirstName] nvarchar(128) NULL;

DECLARE @var10 sysname;
SELECT @var10 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'Email');
IF @var10 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var10 + '];');
ALTER TABLE [Users] ALTER COLUMN [Email] nvarchar(256) NULL;

DECLARE @var11 sysname;
SELECT @var11 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Users]') AND [c].[name] = N'DateOfBirth');
IF @var11 IS NOT NULL EXEC(N'ALTER TABLE [Users] DROP CONSTRAINT [' + @var11 + '];');
ALTER TABLE [Users] ALTER COLUMN [DateOfBirth] datetime2 NULL;

DECLARE @var12 sysname;
SELECT @var12 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Roles]') AND [c].[name] = N'Name');
IF @var12 IS NOT NULL EXEC(N'ALTER TABLE [Roles] DROP CONSTRAINT [' + @var12 + '];');
ALTER TABLE [Roles] ALTER COLUMN [Name] nvarchar(20) NULL;

DECLARE @var13 sysname;
SELECT @var13 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Reviews]') AND [c].[name] = N'Rating');
IF @var13 IS NOT NULL EXEC(N'ALTER TABLE [Reviews] DROP CONSTRAINT [' + @var13 + '];');
ALTER TABLE [Reviews] ALTER COLUMN [Rating] decimal(18,2) NULL;

DECLARE @var14 sysname;
SELECT @var14 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Reviews]') AND [c].[name] = N'CreatedDate');
IF @var14 IS NOT NULL EXEC(N'ALTER TABLE [Reviews] DROP CONSTRAINT [' + @var14 + '];');
ALTER TABLE [Reviews] ALTER COLUMN [CreatedDate] datetime2 NULL;

DECLARE @var15 sysname;
SELECT @var15 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Purchases]') AND [c].[name] = N'TotalPrice');
IF @var15 IS NOT NULL EXEC(N'ALTER TABLE [Purchases] DROP CONSTRAINT [' + @var15 + '];');
ALTER TABLE [Purchases] ALTER COLUMN [TotalPrice] decimal(18,2) NULL;

DECLARE @var16 sysname;
SELECT @var16 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Purchases]') AND [c].[name] = N'PurchaseNumber');
IF @var16 IS NOT NULL EXEC(N'ALTER TABLE [Purchases] DROP CONSTRAINT [' + @var16 + '];');
ALTER TABLE [Purchases] ALTER COLUMN [PurchaseNumber] uniqueidentifier NULL;

DECLARE @var17 sysname;
SELECT @var17 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Purchases]') AND [c].[name] = N'PurchaseDateTime');
IF @var17 IS NOT NULL EXEC(N'ALTER TABLE [Purchases] DROP CONSTRAINT [' + @var17 + '];');
ALTER TABLE [Purchases] ALTER COLUMN [PurchaseDateTime] datetime2 NULL;

DECLARE @var18 sysname;
SELECT @var18 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'UpdatedDate');
IF @var18 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var18 + '];');
ALTER TABLE [Movies] ALTER COLUMN [UpdatedDate] datetime2 NULL;

DECLARE @var19 sysname;
SELECT @var19 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'RunTime');
IF @var19 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var19 + '];');
ALTER TABLE [Movies] ALTER COLUMN [RunTime] int NULL;

DECLARE @var20 sysname;
SELECT @var20 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'Revenue');
IF @var20 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var20 + '];');
ALTER TABLE [Movies] ALTER COLUMN [Revenue] decimal(18,2) NULL;

DECLARE @var21 sysname;
SELECT @var21 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'ReleaseDate');
IF @var21 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var21 + '];');
ALTER TABLE [Movies] ALTER COLUMN [ReleaseDate] datetime2 NULL;

DECLARE @var22 sysname;
SELECT @var22 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'CreatedDate');
IF @var22 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var22 + '];');
ALTER TABLE [Movies] ALTER COLUMN [CreatedDate] datetime2 NULL;

DECLARE @var23 sysname;
SELECT @var23 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'Budget');
IF @var23 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var23 + '];');
ALTER TABLE [Movies] ALTER COLUMN [Budget] decimal(18,2) NULL;

DECLARE @var24 sysname;
SELECT @var24 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Cast]') AND [c].[name] = N'TmbdUrl');
IF @var24 IS NOT NULL EXEC(N'ALTER TABLE [Cast] DROP CONSTRAINT [' + @var24 + '];');
ALTER TABLE [Cast] ALTER COLUMN [TmbdUrl] nvarchar(max) NULL;

DECLARE @var25 sysname;
SELECT @var25 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Cast]') AND [c].[name] = N'ProfilePath');
IF @var25 IS NOT NULL EXEC(N'ALTER TABLE [Cast] DROP CONSTRAINT [' + @var25 + '];');
ALTER TABLE [Cast] ALTER COLUMN [ProfilePath] nvarchar(2084) NULL;

DECLARE @var26 sysname;
SELECT @var26 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Cast]') AND [c].[name] = N'Name');
IF @var26 IS NOT NULL EXEC(N'ALTER TABLE [Cast] DROP CONSTRAINT [' + @var26 + '];');
ALTER TABLE [Cast] ALTER COLUMN [Name] nvarchar(128) NULL;

DECLARE @var27 sysname;
SELECT @var27 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Cast]') AND [c].[name] = N'Gender');
IF @var27 IS NOT NULL EXEC(N'ALTER TABLE [Cast] DROP CONSTRAINT [' + @var27 + '];');
ALTER TABLE [Cast] ALTER COLUMN [Gender] nvarchar(max) NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827223412_EntityFixMigration', N'9.0.8');

DECLARE @var28 sysname;
SELECT @var28 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Movies]') AND [c].[name] = N'Price');
IF @var28 IS NOT NULL EXEC(N'ALTER TABLE [Movies] DROP CONSTRAINT [' + @var28 + '];');
ALTER TABLE [Movies] ALTER COLUMN [Price] decimal(18,2) NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250827224103_EntityFixMigration2', N'9.0.8');

COMMIT;
GO

