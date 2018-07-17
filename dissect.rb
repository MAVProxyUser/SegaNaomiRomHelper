# https://www.arcade-projects.com/forums/index.php?thread/1691-converting-gdrom-naomi-games-to-cart/&postID=88437&highlight=finisterre%2Bheader#post88437
#
# look at ROM header, starting from 360h is 3x 32bit LE numbers - game exe start offset, destination address in RAM, length
# - knowing offset/len extract game exe binary
# - load it in IDA and set Loading address as per "destination address in RAM"
# - look at ROM header at 420h - there is code entry point address

require 'hexdump'

romdata = File.binread(ARGV[0])
puts "Reading values from " + ARGV[0] + ":\n"

# Only 16 bytes here 
# NAOMI header
puts "-----------------------------------------------------------------------------\n"
puts "Platform"
Hexdump.dump(romdata[0..15])

# Print out 32 bytes at a time from now on 
# Company Name
puts "-----------------------------------------------------------------------------\n"
puts "Company"
Hexdump.dump(romdata[16..47])

# Game Name (JAPAN)
puts "-----------------------------------------------------------------------------\n"
puts "Game Name by region"
Hexdump.dump(romdata[48..79])
# Game Name (USA)
Hexdump.dump(romdata[80..111])
# Game Name (EXPORT/EURO)
Hexdump.dump(romdata[112..143])
# Game Name (KOREA/ASIA)
Hexdump.dump(romdata[144..175])
# Game Name (AUSTRALIA)
Hexdump.dump(romdata[176..207])
# Game Name (SAMPLE GAME / RESERVED 1 / RESERVED ?)
Hexdump.dump(romdata[208..239])
# Game Name (SAMPLE GAME / RESERVED 2 / RESERVED !)
Hexdump.dump(romdata[240..271])
# Game Name (SAMPLE GAME / RESERVED 3 / RESERVED @)
Hexdump.dump(romdata[272..303])

# Game ID
puts "-----------------------------------------------------------------------------\n"
puts "Game ID"
Hexdump.dump(romdata[304..335])

# Entry Point
puts "-----------------------------------------------------------------------------\n"
puts "Entry Point: " + romdata[420..423].unpack('H*').to_s


# Is this similar to a Genesis header? 
# https://www.zophar.net/fileuploads/2/10614uauyw/Genesis_ROM_Format.txt
#
# Rom capacity?
# Here you will find the start and end address of the rom,
# respectively. The start address in most cases is 0 and the end address is 
# the size of rom in BYTES. Note that these values don't include the headers
# that some rom images have (discussed later). Each address is 4-bytes long.

# 0x360 is magic... aka 864 in binary 
puts "-----------------------------------------------------------------------------\n"
puts "ROM Capacity"
capacity1 = romdata[864..867]
capacity2 = romdata[868..871]
capacity3 = romdata[872..875]
capacity4 = romdata[876..879]
puts "Start: " + capacity1.unpack('h*').to_s
puts "End: " + capacity2.unpack('h*').to_s
puts "Ram address: " + capacity3.unpack('h*').to_s
#puts capacity4.unpack('h*')

# 360h

