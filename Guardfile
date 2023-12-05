# Guardfile
guard :shell do
  watch(%r{(\d{4})/(\d{2})/solution(\d{2})\.rb}) do |m|
    year, day = m[1], m[2]
    puts "Reloading solution for December #{day}, #{year}..."
    `ruby #{year}/#{day}/solution#{day}.rb`
  end
end
