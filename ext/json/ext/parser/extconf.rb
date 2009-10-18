require 'mkmf'
require 'rbconfig'
include Config

CC = system(cc = CONFIG['CC'], '-v') && cc
if CC
	if CC =~ /gcc/
		$CFLAGS += ' -Wall'
		#$CFLAGS += ' -O0 -ggdb'
	end

	if (method(:have_header) rescue nil)
		have_header("ruby/st.h") || have_header("st.h")
		have_header("re.h")
	end

	warn "Build system found: Installing the EXT variant of JSON."
  create_makefile 'parser'
else
	warn "Build system not found: Installing the PURE variant of JSON instead."
	File.open('Makefile', 'w') do |mf|
		mf.puts <<EOT
all:
	ruby -e 'File.open("parser.#{CONFIG['DLEXT']}", "wb") {}'

static:

clean:

install:

site-install:

distclean:
	ruby -rfileutils -e 'FileUtils.rm_f ARGV'
realclean: distclean
EOT
	end
end
