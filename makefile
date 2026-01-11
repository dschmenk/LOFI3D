HBCC3D =HBCC/ ESCAPE.OBJ.BIN
LIGHTCYCLES = LightCycles/LIGHTCYCLES.BIN
LOFI3D = LOFI3D.SYSTEM.SYS
#
# Image filetypes for Virtual ][
#
PLATYPE	= .\$$ED
BINTYPE	= .BIN
SYSTYPE	= .SYS
TXTTYPE	= .TXT
#
# Image filetypes for CiderPress
#
#RELTYPE	= \#FE1000
#INTERPTYPE	= \#050000
#BINTYPE	= \#060000
#SYSTYPE	= \#FF2000
#TXTTYPE	= \#040000

#lofi3d: $(LOFI3D)

#hbcc: $(HBCC)

all: $(HBCC3D) $(LIGHTCYCLES) $(LOFI3D)

clean:
	-rm $(HBCC3D) $(LIGHTCYCLES) $(LOFI3D)

$(HBCC3D):
	make -C HBCC

$(LIGHTCYCLES):
	make -C LightCycles

$(LOFI3D): lofi3d.s
	acme --setpc 0x2000 --outfile $(LOFI3D) lofi3d.s

