SELECT 'Artist' AS TableName, COUNT(*) AS [RowCount] FROM chinook.Artist
UNION ALL
SELECT 'Album', COUNT(*) FROM chinook.Album
UNION ALL
SELECT 'Track', COUNT(*) FROM chinook.Track
UNION ALL
SELECT 'Invoice', COUNT(*) FROM chinook.Invoice
UNION ALL
SELECT 'InvoiceLine', COUNT(*) FROM chinook.InvoiceLine
UNION ALL
SELECT 'Customer', COUNT(*) FROM chinook.Customer
UNION ALL
SELECT 'Employee', COUNT(*) FROM chinook.Employee
UNION ALL
SELECT 'Genre', COUNT(*) FROM chinook.Genre
UNION ALL
SELECT 'MediaType', COUNT(*) FROM chinook.MediaType
UNION ALL
SELECT 'Playlist', COUNT(*) FROM chinook.Playlist
UNION ALL
SELECT 'PlaylistTrack', COUNT(*) FROM chinook.PlaylistTrack;