CREATE schema chinook;

--Create Tables

CREATE TABLE chinook.Album
(
    AlbumId INT NOT NULL IDENTITY,
    Title NVARCHAR(40) NOT NULL,
    ArtistId INT NOT NULL,
    PRIMARY KEY CLUSTERED (AlbumId)
);

CREATE TABLE chinook.Artist
(
    ArtistId INT NOT NULL IDENTITY,
    Name NVARCHAR(120),
   PRIMARY KEY CLUSTERED (ArtistId)
);

CREATE TABLE chinook.Customer
(
    CustomerId INT NOT NULL IDENTITY,
    FirstName NVARCHAR(40) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Company NVARCHAR(80),
    Address NVARCHAR(70),
    City NVARCHAR(40),
    State NVARCHAR(40),
    Country NVARCHAR(40),
    PostalCode NVARCHAR(10),
    Phone NVARCHAR(24),
    Fax NVARCHAR(24),
    Email NVARCHAR(60) NOT NULL,
    SupportRepId INT,
    PRIMARY KEY CLUSTERED (CustomerId)
);

CREATE TABLE chinook.Employee
(
    EmployeeId INT NOT NULL IDENTITY,
    LastName NVARCHAR(20) NOT NULL,
    FirstName NVARCHAR(20) NOT NULL,
    Title NVARCHAR(30),
    ReportsTo INT,
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(70),
    City NVARCHAR(40),
    State NVARCHAR(40),
    Country NVARCHAR(40),
    PostalCode NVARCHAR(10),
    Phone NVARCHAR(24),
    Fax NVARCHAR(24),
    Email NVARCHAR(60),
    PRIMARY KEY CLUSTERED (EmployeeId)
);

CREATE TABLE chinook.Genre
(
    GenreId INT NOT NULL IDENTITY,
    Name NVARCHAR(120),
    PRIMARY KEY CLUSTERED (GenreId)
);

CREATE TABLE chinook.Invoice
(
    InvoiceId INT NOT NULL IDENTITY,
    CustomerId INT NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    BillingAddress NVARCHAR(70),
    BillingCity NVARCHAR(40),
    BillingState NVARCHAR(40),
    BillingCountry NVARCHAR(40),
    BillingPostalCode NVARCHAR(10),
    Total NUMERIC(10,2) NOT NULL,
    CONSTRAINT PK_Invoice PRIMARY KEY CLUSTERED (InvoiceId)
);

CREATE TABLE chinook.InvoiceLine
(
    InvoiceLineId INT NOT NULL IDENTITY,
    InvoiceId INT NOT NULL,
    TrackId INT NOT NULL,
    UnitPrice NUMERIC(10,2) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY CLUSTERED (InvoiceLineId)
);

CREATE TABLE chinook.MediaType
(
    MediaTypeId INT NOT NULL IDENTITY,
    Name NVARCHAR(120),
    CONSTRAINT PK_MediaType PRIMARY KEY CLUSTERED (MediaTypeId)
);
GO
CREATE TABLE chinook.Playlist
(
    PlaylistId INT NOT NULL IDENTITY,
    Name NVARCHAR(120),
    CONSTRAINT PK_Playlist PRIMARY KEY CLUSTERED (PlaylistId)
);
GO
CREATE TABLE chinook.PlaylistTrack
(
    PlaylistId INT NOT NULL,
    TrackId INT NOT NULL,
    PRIMARY KEY NONCLUSTERED (PlaylistId, TrackId)
);
GO
CREATE TABLE chinook.Track
(
    TrackId INT NOT NULL IDENTITY,
    Name NVARCHAR(200) NOT NULL,
    AlbumId INT,
    MediaTypeId INT NOT NULL,
    GenreId INT,
    Composer NVARCHAR(220),
    Milliseconds INT NOT NULL,
    Bytes INT,
    UnitPrice NUMERIC(10,2) NOT NULL,
    PRIMARY KEY CLUSTERED (TrackId)
);

--Define Relationships

ALTER TABLE chinook.Album ADD CONSTRAINT FK_AlbumArtistId
    FOREIGN KEY (ArtistId) REFERENCES chinook.Artist (ArtistId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_AlbumArtistId ON chinook.Album (ArtistId);
GO
ALTER TABLE chinook.Customer ADD CONSTRAINT FK_CustomerSupportRepId
    FOREIGN KEY (SupportRepId) REFERENCES chinook.Employee (EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_CustomerSupportRepId ON chinook.Customer (SupportRepId);
GO
ALTER TABLE chinook.Employee ADD CONSTRAINT FK_EmployeeReportsTo
    FOREIGN KEY (ReportsTo) REFERENCES chinook.Employee (EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_EmployeeReportsTo ON chinook.Employee (ReportsTo);
GO
ALTER TABLE chinook.Invoice ADD CONSTRAINT FK_InvoiceCustomerId
    FOREIGN KEY (CustomerId) REFERENCES chinook.Customer (CustomerId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_InvoiceCustomerId ON chinook.Invoice (CustomerId);
GO
ALTER TABLE chinook.InvoiceLine ADD CONSTRAINT FK_InvoiceLineInvoiceId
    FOREIGN KEY (InvoiceId) REFERENCES chinook.Invoice (InvoiceId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_InvoiceLineInvoiceId ON chinook.InvoiceLine (InvoiceId);
GO
ALTER TABLE chinook.InvoiceLine ADD CONSTRAINT FK_InvoiceLineTrackId
    FOREIGN KEY (TrackId) REFERENCES chinook.Track (TrackId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_InvoiceLineTrackId ON chinook.InvoiceLine (TrackId);
GO
ALTER TABLE chinook.PlaylistTrack ADD CONSTRAINT FK_PlaylistTrackPlaylistId
    FOREIGN KEY (PlaylistId) REFERENCES chinook.Playlist (PlaylistId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE chinook.PlaylistTrack ADD CONSTRAINT FK_PlaylistTrackTrackId
    FOREIGN KEY (TrackId) REFERENCES chinook.Track (TrackId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_PlaylistTrackTrackId ON chinook.PlaylistTrack (TrackId);
GO
ALTER TABLE chinook.Track ADD CONSTRAINT FK_TrackAlbumId
    FOREIGN KEY (AlbumId) REFERENCES chinook.Album (AlbumId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_TrackAlbumId ON chinook.Track (AlbumId);
GO
ALTER TABLE chinook.Track ADD CONSTRAINT FK_TrackGenreId
    FOREIGN KEY (GenreId) REFERENCES chinook.Genre (GenreId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_TrackGenreId ON chinook.Track (GenreId);
GO
ALTER TABLE chinook.Track ADD CONSTRAINT FK_TrackMediaTypeId
    FOREIGN KEY (MediaTypeId) REFERENCES chinook.MediaType (MediaTypeId) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
CREATE INDEX IFK_TrackMediaTypeId ON chinook.Track (MediaTypeId);


ALTER TABLE chinook.Album 
ALTER COLUMN Title NVARCHAR(200);

