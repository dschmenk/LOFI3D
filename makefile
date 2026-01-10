HBCC3D = ESCAPE.OBJ.BIN
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

all: $(HBCC3D) $(LOFI3D)

clean:
	-rm $(HBCC3D) $(LOFI3D) *.o

main.o: global.inc main.s
	ca65 main.s

math.o: global.inc math.s
	ca65 math.s

player.o: global.inc player.s
	ca65 player.s

raycast.o: global.inc raycast.s
	ca65 raycast.s

render.o: global.inc render.s
	ca65 render.s

sfx.o: global.inc sfx.s
	ca65 sfx.s

$(HBCC3D): main.o math.o player.o raycast.o render.o sfx.o
	cl65 -C apple2bin.cfg main.o math.o player.o raycast.o render.o sfx.o -o $(HBCC3D)

$(LOFI3D): lofi3d.s
	acme --setpc 0x2000 --outfile $(LOFI3D) lofi3d.s

