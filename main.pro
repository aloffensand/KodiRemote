
isEmpty(PREFIX) {
  PREFIX = /usr/local
}
BINDIR = $$PREFIX/bin
DATADIR = $$PREFIX/share

TARGET = KodiRemote
;TEMPLATE += app
QT += qml widgets
SOURCES += main.cpp
RESOURCES = resources.qrc

target.path = $$BINDIR
desktop.path = $$DATADIR/applications
desktop.files = KodiRemote.desktop

INSTALLS += target desktop
