require 'csv'

class ExportController < ApplicationController
  def export_to_csv
    data = Address::Region.includes(provinces: { cities: :barangays })

    csv_data = CSV.generate do |csv|
      data.each do |region|
        csv << ["Region: #{region.name}"]

        region.provinces.each do |province|
          csv << ["Province: #{province.name}"]

          province.cities.each do |city|
            csv << ["City: #{city.name}"]

            city.barangays.each do |barangay|
              csv << ["Barangay: #{barangay.name}"]
            end
          end
        end
      end
    end

    send_data csv_data, filename: 'philippine_data.csv'
  end
end
