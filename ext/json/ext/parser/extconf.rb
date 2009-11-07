require 'mkmf'
require 'rbconfig'
include Config

def fake_makefile(source)
  puts "Build system not found: Installing the PURE variant of JSON instead."
  File.open('Makefile', 'w') do |mf|
    mf.puts <<EOT
all:
	ruby -e 'File.open("#{source}.#{CONFIG['DLEXT']}", "wb") {}'

static:

clean:

install:

site-install:

distclean:
	ruby -rfileutils -e 'FileUtils.rm_f ARGV'
realclean: distclean
EOT
	end
  exit 42
end

CC = system(cc = CONFIG['CC'], '-v') && cc
if CC
  unless $CFLAGS.gsub!(/ -O[\dsz]?/, ' -O3')
    $CFLAGS << ' -O3'
  end

  if CC =~ /gcc/
    $CFLAGS << ' -Wall'
    #$CFLAGS.gsub!(/ -O[\dsz]?/, ' -O0 -ggdb')
  end

  if (method(:have_header) rescue nil)
    have_header("ruby/st.h") || have_header("st.h")
    have_header("re.h")
    puts "Build system found: Installing the EXT variant of JSON."
    create_makefile 'parser'
  else
    fake_makefile 'parser'
  end
else
  fake_makefile 'parser'
end
