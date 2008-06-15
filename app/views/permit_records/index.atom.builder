atom_feed(:url => formatted_incidents_url(:atom)) do |feed|
  feed.title("ENotify Permit Records")
  feed.updated(@permit_records.first ? @permit_records.first.created_at : Time.now.utc)

  for incident in @permit_records
    feed.entry(incident) do |entry|
      entry.title(incident.description)
      entry.content(render(:partial => "incidents/incident", :object => incident), :type => 'html')

      entry.author do |author|
        author.name('Milwaukee ENotify')
        author.email('MilwaukeeE-Notify@milwaukee.gov')
      end
    end
  end
end
