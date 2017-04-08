SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[uspAddCoverDesc]
AS -- Update Single
    UPDATE  tblEDI_App_Subscr
    SET     CoverID = 1
    WHERE   SubID IN (
            SELECT  SubID
            FROM    dbo.tblEDI_App_Subscr
            WHERE   SubID NOT IN (
                    SELECT  SubID
                    FROM    dbo.tblEDI_App_Subscr s
                            INNER JOIN tblEDI_App_Dep d ON s.SubSSN = d.DepSubID ) );
-- Update Employee + Spouse
    UPDATE  tblEDI_App_Subscr
    SET     CoverID = 2
    WHERE   SubID IN (
            SELECT  SubID
            FROM    ( SELECT    s.SubID
                      FROM      dbo.tblEDI_App_Subscr s
                                LEFT OUTER JOIN tblEDI_App_Dep d ON s.SubSSN = d.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID
                                                ) AS dc ON s.SubSSN = dc.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            DepAge ,
                                                            DepRelationship ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID ,
                                                            DepAge ,
                                                            DepRelationship
                                                ) AS dp ON s.SubSSN = dp.DepSubID
                      WHERE     s.SubGroupID != 'INDIV'
                                AND dc.DepCnt = 1
                                AND s.CoverID = 2
                                AND d.DepRelationship = 'S'
                    ) AS ss
            GROUP BY SubID );
-- Update Employee + Child
    UPDATE  tblEDI_App_Subscr
    SET     CoverID = 3
    WHERE   SubID IN (
            SELECT  SubID
            FROM    ( SELECT    s.SubID
                      FROM      dbo.tblEDI_App_Subscr s
                                LEFT OUTER JOIN tblEDI_App_Dep d ON s.SubSSN = d.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID
                                                ) AS dc ON s.SubSSN = dc.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            DepAge ,
                                                            DepRelationship ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID ,
                                                            DepAge ,
                                                            DepRelationship
                                                ) AS dp ON s.SubSSN = dp.DepSubID
                      WHERE     s.SubGroupID != 'INDIV'
                                AND dc.DepCnt = 1
                                AND s.CoverID IN ( 2, 3 )
                                AND d.DepRelationship = 'C'
                    ) AS ss
            GROUP BY SubID );
-- Update Family
    UPDATE  tblEDI_App_Subscr
    SET     CoverID = 4
    WHERE   SubID IN (
            SELECT  SubID
            FROM    ( SELECT    s.SubID
                      FROM      dbo.tblEDI_App_Subscr s
                                LEFT OUTER JOIN tblEDI_App_Dep d ON s.SubSSN = d.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID
                                                ) AS dc ON s.SubSSN = dc.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            DepAge ,
                                                            DepRelationship ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID ,
                                                            DepAge ,
                                                            DepRelationship
                                                ) AS dp ON s.SubSSN = dp.DepSubID
                      WHERE     s.SubGroupID != 'INDIV'
                                AND dc.DepCnt > 1
                                AND s.CoverID = 4
                    ) AS ss
            GROUP BY SubID );
-- Update Employee + Children
    UPDATE  tblEDI_App_Subscr
    SET     CoverID = 3
    WHERE   SubID IN (
            SELECT  SubID
            FROM    ( SELECT    s.SubID
                      FROM      dbo.tblEDI_App_Subscr s
                                LEFT OUTER JOIN tblEDI_App_Dep d ON s.SubSSN = d.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID
                                                ) AS dc ON s.SubSSN = dc.DepSubID
                                LEFT OUTER JOIN ( SELECT    DepSubID ,
                                                            DepAge ,
                                                            DepRelationship ,
                                                            COUNT(DepSubID) AS DepCnt
                                                  FROM      tblEDI_App_Dep
                                                  GROUP BY  DepSubID ,
                                                            DepAge ,
                                                            DepRelationship
                                                ) AS dp ON s.SubSSN = dp.DepSubID
                      WHERE     s.SubGroupID != 'INDIV'
                                AND dc.DepCnt > 1
                                AND s.CoverID = 3
                    ) AS ss
            GROUP BY SubID );
GO
