namespace :spree do
  namespace :extensions do
    namespace :related_products do
      
      desc "Copies all migrations (NOTE: This will be obsolete with Rails 3.1)"
      task :migrations do
        source = File.join(File.dirname(__FILE__), '..', '..', 'db')
        destination = File.join(Rails.root, 'db')
        puts "INFO: Mirroring assets from #{source} to #{destination}"
        Spree::FileUtilz.mirror_files(source, destination)
      end
      
      desc "Copies public assets of the Related Products to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[RelationsExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(RelationsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
    end
  end
end
