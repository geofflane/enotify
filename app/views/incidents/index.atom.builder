atom_feed(:url => formatted_incidents_url(:atom)) do |feed|
  feed.title("ENotify Crime Incidents")
  feed.updated(@incidents.first ? @incidents.first.created_at : Time.now.utc)

  for incident in @incidents
    feed.entry(incident) do |entry|
      entry.title(incident.description)
      entry.content(render(:partial => "incident", :object => incident), :type => 'html')

      entry.author do |author|
        author.name('Milwaukee ENotify')
        author.email('MilwaukeeE-Notify@milwaukee.gov')
      end
    end
  end
end
