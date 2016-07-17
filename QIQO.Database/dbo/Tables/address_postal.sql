CREATE TABLE [dbo].[address_postal] (
    [country]         VARCHAR (50) NOT NULL,
    [postal_code]     VARCHAR (20) NULL,
    [state_code]      VARCHAR (2)  NULL,
    [state_full_name] VARCHAR (30) NULL,
    [city_name]       VARCHAR (27) NULL,
    [county_name]     VARCHAR (50) NULL,
    [time_zone]       INT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-20150809-131423]
    ON [dbo].[address_postal]([country] ASC, [postal_code] ASC, [state_code] ASC, [state_full_name] ASC, [city_name] ASC, [county_name] ASC);

