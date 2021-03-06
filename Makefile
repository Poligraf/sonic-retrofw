
CXX = mipsel-linux-g++
CXXFLAGS_ALL = $(shell pkg-config --cflags --static sdl vorbisfile vorbis) $(CXXFLAGS) \
									-DFORCESDL1 -DRETRO_DISABLE_LOG -Ofast \
									-fomit-frame-pointer -ffunction-sections -ffast-math  -G0 -mbranch-likely -fno-common \
									-falign-functions -falign-labels -falign-loops -falign-jumps \
									-ffast-math -fsingle-precision-constant -funsafe-math-optimizations \
									-fomit-frame-pointer -fno-builtin -fno-exceptions \
									-fstrict-aliasing  -fexpensive-optimizations  \
									-finline -finline-functions -fpeel-loops \
									-fdata-sections -ffunction-sections  \
									-flto -fwhole-program -fuse-linker-plugin -fmerge-all-constants \
									-funswitch-loops -fno-strict-aliasing -ftree-vectorize \
									-mips32 -mtune=mips32 -mno-mips16 -mno-shared -mbranch-likely -pipe \
									-fprofile-use -fprofile-dir=./profile#

LDFLAGS_ALL = $(LDFLAGS)
LIBS_ALL = $(shell pkg-config --libs --static sdl vorbisfile vorbis) -pthread $(LIBS)

SOURCES = Sonic12Decomp/Animation.cpp     \
          Sonic12Decomp/Audio.cpp         \
          Sonic12Decomp/Collision.cpp     \
          Sonic12Decomp/Debug.cpp         \
          Sonic12Decomp/Drawing.cpp       \
          Sonic12Decomp/Ini.cpp           \
          Sonic12Decomp/Input.cpp         \
          Sonic12Decomp/main.cpp          \
          Sonic12Decomp/Math.cpp          \
          Sonic12Decomp/Network.cpp       \
          Sonic12Decomp/Object.cpp        \
          Sonic12Decomp/Palette.cpp       \
          Sonic12Decomp/PauseMenu.cpp     \
          Sonic12Decomp/Reader.cpp        \
          Sonic12Decomp/RetroEngine.cpp   \
          Sonic12Decomp/RetroGameLoop.cpp \
          Sonic12Decomp/Scene.cpp         \
          Sonic12Decomp/Scene3D.cpp       \
          Sonic12Decomp/Script.cpp        \
          Sonic12Decomp/Sprite.cpp        \
          Sonic12Decomp/String.cpp        \
          Sonic12Decomp/Text.cpp          \
          Sonic12Decomp/Userdata.cpp      \

ifneq ($(FORCE_CASE_INSENSITIVE),)
	CXXFLAGS_ALL += -DFORCE_CASE_INSENSITIVE
	SOURCES += Sonic12Decomp/fcaseopen.c
endif

objects/%.o: %
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS_ALL) $^ -o $@ -c

bin/sonic2013: $(SOURCES:%=objects/%.o)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS_ALL) $(LDFLAGS_ALL) $^ -o $@ $(LIBS_ALL)
	cp bin/sonic2013 squashfs-root;
	mksquashfs squashfs-root/ sonic.opk -all-root -noappend -no-exports -no-xattrs;

install: bin/sonic2013
	install -Dp -m755 bin/sonic2013 $(prefix)/bin/sonic2013;



clean:
	rm -r -f bin && rm -r -f objects
