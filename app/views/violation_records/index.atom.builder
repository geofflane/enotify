atom_feed(:url => formatted_violation_records_url(:atom)) do |feed|
  feed.title("ENotify Service Requests")
  feed.updated(@violation_records.first ? @violation_records.first.created_at : Time.now.utc)

  for incident in @violation_records
    feed.entry(incident) do |entry|
      entry.title(incident.description)
      entry.content(render(:partial => "incidents/incident", :object => incident), :type => 'html')
	  entry.content(incident.to_ical.to_ical, :type => 'text/calendar')
	  entry.content(incident.to_kml, :type => 'application/vnd.google-earth.kml+xml')

      entry.author do |author|
        author.name('Milwaukee ENotify')
        author.email('MilwaukeeE-Notify@milwaukee.gov')
      end
    end
  end
end
