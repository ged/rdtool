#!/usr/bin/env rake

require 'pathname'
require 'hoe'

# Directory and target constants

BASEDIR      = Pathname( __FILE__ ).dirname
LIBDIR       = BASEDIR + 'lib'
LIBRDDIR     = LIBDIR + 'rd'

RACC_FILES   = Rake::FileList[ (LIBRDDIR + '*.ry').to_s ]
TABLE_FILES  = RACC_FILES.pathmap( "%X.tab.rb" )

RACC_LOGFILE = 'racc.out'

# Hoe config
Hoe.add_include_dirs( 'lib' )

Hoe.plugin :mercurial
Hoe.plugin :signing

Hoe.plugins.delete :rubyforge

hoespec = Hoe.spec 'rdtool' do
	self.readme_file = 'README.rd'
	self.history_file = 'HISTORY.rd'

	self.developer 'Michael Granger', 'ged@FaerieMUD.org'

	self.extra_dev_deps.push *{
		'rspec' => '~> 2.4',
	}

	self.spec_extras[:licenses] = ['Ruby', 'GPL']
	self.spec_extras[:signing_key] = '/Volumes/Keys/ged-private_gem_key.pem'

	self.require_ruby_version( '>=1.8.7' )

	self.hg_sign_tags = true if self.respond_to?( :hg_sign_tags= )

    self.test_globs = ['test/**/test-*.rb']
	self.need_rdoc = false
	self.rdoc_locations << "deveiate:/usr/local/www/public/code/#{remote_rdoc_dir}"
end


# Work around the release task's VERSION=x.y.z safeguard, as the mercurial task
# already checks the release version against the existing tags
ENV['VERSION'] ||= hoespec.spec.version.to_s

# Ensure the tests pass before checking in
task 'hg:precheckin' => :test

# declared because :clean depends on this even if #need_rdoc == false
task :clobber_docs do
end


# Mercurial-related tasks
begin
	include Hoe::MercurialHelpers

	### Task: prerelease
	desc "Append the package build number to package versions"
	task :pre do
		rev = get_numeric_rev()
		trace "Current rev is: %p" % [ rev ]
		hoespec.spec.version.version << "pre#{rev}"
		Rake::Task[:gem].clear

		Gem::PackageTask.new( hoespec.spec ) do |pkg|
			pkg.need_zip = true
			pkg.need_tar = true
		end
	end

	### Make the ChangeLog update if the repo has changed since it was last built
	file '.hg/branch'
	file 'ChangeLog' => '.hg/branch' do |task|
		$stderr.puts "Updating the changelog..."
		content = make_changelog()
		File.open( task.name, 'w', 0644 ) do |fh|
			fh.print( content )
		end
	end

	# Rebuild the ChangeLog immediately before release
	task :prerelease => 'ChangeLog'

rescue NameError => err
	task :no_hg_helpers do
		fail "Couldn't define the :pre task: %s: %s" % [ err.class.name, err.message ]
	end

	task :pre => :no_hg_helpers
	task 'ChangeLog' => :no_hg_helpers

end


# RD -> HTML rule
rule '.html' => '.rd' do |task|
	require 'rd/rdfmt'
	require 'rd/rd2html-lib'

	trace "#{task.source} -> #{task.name}"
	src = File.readlines( task.source )
	trace "  read %d lines..." % [ src.length ]
	if src.find {|line| line =~ /\S/ } and !src.find {|line| line =~ /^=begin\b/ }
		trace "  wrapping content in =begin and =end..."
		src.unshift( "=begin\n" ).push( "=end\n" )
	end

	trace "  setting up RD tree..."
	tree = RD::RDTree.new( src, [File.dirname(task.source)] )

	trace "  setting up RD HTML visitor..."
	visitor = RD::RD2HTMLVisitor.new
	visitor.filename = task.name
	visitor.charcode = 'utf8'
    visitor.lang = task.source =~ /\.ja\,/ ? 'ja' : 'en'

	trace "  rendering..."
	output = visitor.visit( tree )

	trace "  writing #{task.name}..."
	File.open( task.name, File::WRONLY|File::TRUNC|File::CREAT, 0644 ) do |ofh|
		ofh.print( output )
	end
end

task :test => TABLE_FILES

# .ry -> .tab.rb rule (Racc grammars)
rule( /\.tab\.rb$/ => [proc {|name| name.sub(/\.tab\.rb$/, '.ry')}] ) do |task|
	log "Generating #{task.name}"
	run 'racc', '-v', '-O', RACC_LOGFILE, '-o', task.name, task.source
end
CLEAN.include( RACC_LOGFILE )
CLOBBER.include( TABLE_FILES )


