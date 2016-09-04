DECLARE SUB KBR ()
DECLARE SUB READDATA ()
DECLARE SUB INITUNIVERSE ()
DECLARE SUB SIMULATE ()
DECLARE SUB RENDER ()
REM
REM  P1X ANSI COLONY SIMULATOR
REM
REM  VERSION ALPHA-4
REM
REM  KRZYSZTOF JANKOWSKI
REM
REM

SCREEN 9
WIDTH 80, 43
CLS

APPVER$ = "ALPHA-4"
DNAHASH% = TIME
RANDOMIZE DNAHASH%

UNITIME% = 0
POPULATION% = 0
UNISIZEX% = 80
UNISIZEY% = 40
CELLEMPTY% = 0
CELLTYPE1% = 176
CELLTYPE2% = 177
CELLTYPE3% = 178
CELLTYPE4% = 219

CELLCOLOR% = 15
WEBCOLOR% = 1
BGCOLOR% = 15
GUICOLOR% = 5
PLAYERCOLOR% = 3

LIFECHANCE% = 5
BUILDCHANCE% = 20
DESTROYCHANCE% = 20
DECRESECHANCE% = 30
INCRESECHANCE% = 30
REGENERATECHANCE% = 50

PLAYERX% = UNISIZEX% / 2
PLAYERY% = UNISIZEY% / 2

DATA 0,0,0,0,0,0,6,0,0,0,1,0,4
DATA 0,9,0,0,0,5,0,2,0,10,0
DATA 3,0,7,0,8,0,11,-1

DATA 254,179,196,191,218,217,192
DATA 180,194,195,193,197,-1

DIM SHARED UNIVERSE(UNISIZEX%, UNISIZEY%) AS INTEGER
DIM SHARED PATH9MATRIX(31) AS INTEGER
DIM SHARED PATH9ANSI(12) AS INTEGER

CALL READDATA
CALL INITUNIVERSE

DEF FNCOUNTCELLS (X%, Y%)
  B% = 0
  IF Y% > 0 THEN
        IF UNIVERSE(X%, Y% - 1) = 11 THEN
          B% = B% + 2
        END IF
  END IF
  IF Y% < UNISIZEY% THEN
       
        IF UNIVERSE(X%, Y% + 1) = 11 THEN
          B% = B% + 8
        END IF
  END IF
  IF X% > 0 THEN
        IF UNIVERSE(X% - 1, Y%) = 11 THEN
          B% = B% + 16
        END IF
  END IF
  IF X% < UNISIZEX% THEN
        IF UNIVERSE(X% + 1, Y%) = 11 THEN
          B% = B% + 4
        END IF
  END IF
 
  FNCOUNTCELLS = B%
END DEF


DO
  K$ = INKEY$
  CALL KBR
  CALL RENDER
  CALL SIMULATE
LOOP UNTIL K$ = "Q"

SUB DEBUG
PRINT "DEBUG"
PRINT "PATH9MATRIX: ";
FOR I = 0 TO 29
PRINT PATH9MATRIX(I);
NEXT I
PRINT ""
PRINT "PATH9ANSI: ";
FOR J = 0 TO 11
PRINT PATH9ANSI(J);
NEXT J

PRINT ""
PRINT "CONTINUE"
INPUT WAIT$
END SUB

SUB INITUNIVERSE
        SHARED UNISIZEX%
        SHARED UNISIZEY%
        SHARED LIFECHANCE%
        SHARED PLAYERX%
        SHARED PLAYERY%

        FOR Y% = 0 TO UNISIZEY% STEP 1
                FOR X% = 0 TO UNISIZEX% STEP 1
                        NEWCELL% = 0
                        IF INT(RND * 1000) < LIFECHANCE% THEN
                                NEWCELL% = 5
                        END IF
                        IF X% = PLAYERX% AND Y% = PLAYERY% THEN
                                NEWCELL% = 5
                        END IF
                        UNIVERSE(X%, Y%) = NEWCELL%
                NEXT X%
        NEXT Y%
END SUB

SUB KBR
        SHARED PLAYERX%
        SHARED PLAYERY%
        SHARED K$
        
        OLDX% = PLAYERX%
        OLDY% = PLAYERY%
        T% = UNIVERSE(PLAYERX%, PLAYERY%)

        IF K$ = "W" THEN PLAYERY% = PLAYERY% - 1
        IF K$ = "S" THEN PLAYERY% = PLAYERY% + 1
        IF K$ = "A" THEN PLAYERX% = PLAYERX% - 1
        IF K$ = "D" THEN PLAYERX% = PLAYERX% + 1
       
        UNIVERSE(OLDX%, OLDY%) = 0
        UNIVERSE(PLAYERX%, PLAYERY%) = T%
END SUB

SUB MENU

        PRINT "P1X ANSI COLONY SIMULATOR"
        FOR A = 0 TO UNISIZEX% STEP 1
        PRINT CHR$(205);
        NEXT A
        PRINT ""
        PRINT ""

        PRINT "[1] NEW COLONY"
        PRINT "[2] INTRODUCTION"
        PRINT "[3] CREDITS"
        INPUT "CHOOSE OPTION:"; YESNO%

END SUB

SUB READDATA
I% = 0
J% = 0

DO
 READ A%
 IF A% = -1 THEN EXIT DO
 PATH9MATRIX(I%) = A%
 I% = I% + 1
LOOP

DO
 READ B%
 IF B% = -1 THEN EXIT DO
 PATH9ANSI(J%) = B%
 J% = J% + 1
LOOP

END SUB

SUB RENDER
        SHARED APPVER$
        SHARED UNITIME%
        SHARED POPULATION%
        SHARED UNISIZEX%
        SHARED UNISIZEY%
        SHARED CELLEMPTY%
        SHARED CELLTYPE1%
        SHARED CELLTYPE2%
        SHARED CELLTYPE3%
        SHARED CELLTYPE4%
        SHARED CELLCOLOR%
        SHARED WEBCOLOR%
        SHARED BGCOLOR%
        SHARED GUICOLOR%
        SHARED PLAYERCOLOR%
        SHARED PLAYERX%
        SHARED PLAYERY%


        LOCATE 1, 1
        FOR Y = 0 TO UNISIZEY% - 1 STEP 1
          FOR X = 0 TO UNISIZEX% - 1 STEP 1
            CELL = UNIVERSE(X, Y)
            IF CELL = 0 THEN
                PRINT CHR$(CELLEMPTY%);
            END IF
           
            IF X = PLAYERX% AND Y = PLAYERY% THEN
                COLOR PLAYERCOLOR%, BGCOLOR%
            ELSE
                COLOR CELLCOLOR%, BGCOLOR%
            END IF
           
            IF CELL > 0 AND CELL <= 3 THEN
                PRINT CHR$(CELLTYPE1%);
            END IF
            IF CELL > 3 AND CELL <= 6 THEN
                PRINT CHR$(CELLTYPE2%);
            END IF
           
            IF CELL > 6 AND CELL <= 9 THEN
                PRINT CHR$(CELLTYPE3%);
            END IF

            IF CELL = 10 THEN
                PRINT CHR$(CELLTYPE4%);
            END IF
            
            COLOR WEBCOLOR%, BGCOLOR%

            IF CELL = 11 THEN
                PRINT CHR$(PATH9ANSI(PATH9MATRIX(FNCOUNTCELLS(X, Y))));
                REM PRINT FNCOUNTCELLS(X, Y)
            END IF

          NEXT X
          IF Y < UNISIZEY% - 1 THEN
                PRINT ""
          END IF
        NEXT Y

        COLOR GUICOLOR%, BGCOLOR%

        PRINT ""
        PRINT ""
        PRINT APPVER$,
        PRINT "SIZE:"; UNISIZEX%; "X"; UNISIZEY%;
        PRINT ", CYCLES:"; UNITIME%, "[Q]UIT";
        
END SUB

SUB SIMULATE
        SHARED UNITIME%
        SHARED POPULATION%
        SHARED UNISIZEX%
        SHARED UNISIZEY%
        SHARED BUILDCHANCE%
        SHARED DESTROYCHANCE%
        SHARED INCRESECHANCE%
        SHARED DECRESECHANCE%
        SHARED REGENERATECHANCE%
        SHARED PLAYERX%
        SHARED PLAYERY%

        FOR X% = 0 TO UNISIZEX% STEP 1
          FOR Y% = 0 TO UNISIZEY% STEP 1
                IF X% = PLAYERX% AND Y% = PLAYERY% THEN GOTO SKIPME
                T% = UNIVERSE(X%, Y%)
                IF T% > 0 AND T% < 10 THEN
                  R% = INT(RND * 4)
                  NX% = 0
                  NY% = 0
                  CELLAFTER% = 0
         
                  IF R% = 0 AND Y% > 0 THEN
                        NY% = -1
                  END IF
                  IF R% = 1 AND X% < UNISIZEX% THEN
                        NX% = 1
                  END IF
                  IF R% = 2 AND Y% < UNISIZEY% THEN
                        NY% = 1
                  END IF
                  IF R% = 3 AND X% > 0 THEN
                        NX% = -1
                  END IF
               
                  E% = 0
                  IF UNIVERSE(X% + NX%, Y% + NY%) = 0 THEN
                        E% = 0
                        IF INT(RND * 100) < BUILDCHANCE% + T% THEN
                                CELLAFTER% = 11
                                
                                IF INT(RND * 100) < INCRESECHANCE% THEN
                                        E% = 1
                                END IF
                        END IF

                        UNIVERSE(X%, Y%) = CELLAFTER%
                        UNIVERSE(X% + NX%, Y% + NY%) = T% + E%
                  END IF

                 
                  IF UNIVERSE(X% + NX%, Y% + NY%) = 11 THEN
                        E% = 0
                        IF INT(RND * 100) < DESTROYCHANCE% - T% THEN
                                IF INT(RND * 100) < DECRESECHANCE% THEN
                                        E% = 1
                                END IF
                               
                                UNIVERSE(X%, Y%) = T% - E%
                                UNIVERSE(X% + NX%, Y% + NY%) = 0
                        END IF
                  END IF

                  IF UNIVERSE(X% + NX%, Y% + NY%) = 10 THEN
                        IF INT(RND * 100) < REGENERATECHANCE% THEN
                                UNIVERSE(X%, Y%) = 5
                                UNIVERSE(X% + NX%, Y% + NY%) = 5
                        END IF
                  END IF
                 
                END IF
SKIPME:
          NEXT Y%
        NEXT X%

        UNITIME% = UNITIME% + 1

END SUB

