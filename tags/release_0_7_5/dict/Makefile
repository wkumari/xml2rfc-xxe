all:	ietf-words.dar

# Quite a few levels of indirection here!

ietf-words.wl:
	wget http://tools.ietf.org/tools/idspell/ietf-words.wl

ietf-words.txt:	ietf-words.wl
	tail +2 ietf-words.wl > ietf-words.txt

# dictbuilder from http://www.xmlmind.com/spellchecker/dictbuilder.shtml
ietf-words.cdi:	ietf-words.txt
	dictbuilder -o ietf-words.cdi ietf-words.txt

ietf-words.dar:	ietf-words.cdi
	jar cvf ietf-words.dar ietf-words.cdi default
