require 'rake'
require 'csv'

namespace :import do
    desc "Imports model from a csv"
    task model_from_csv: :environment do  |t, args|
        filename = ARGV[1]
        headers, fields = get_headers(filename)

        modelname = ARGV[2]
        system("rails generate model #{modelname} #{fields.join(" ")}")
        system("rails db:migrate")
    end

    desc "Imports data from a csv"
    task data_from_csv: :environment do  |t, args|
        filename = ARGV[1]
        headers, fields = get_headers(filename)
    
        file = CSV.read(filename)
        batch, batch_size = [], 1000 

        modelname = ARGV[2]
        model = modelname.safe_constantize
        file.each_with_index.map do |row, row_index|
            next if row_index < 2
            hash = row.each_with_index.map do |field, index|
                [headers[index], field]
            end.to_h
            batch << model.new(hash)
        end

        model.import(batch,batch_size: batch_size)
    end

    def get_headers(filename="./lib/tasks/Metro_sales_count_now_uc_sfrcondo_month.csv")
        file = File.read(filename).split
        headers = file.shift.split(",").map do |a|
            is_date = /^\d{4}/ === a
            "#{is_date ? "#{Date.parse(a,"%Y-%m-%d").strftime("%b%Y")}": a}"
        end
        types = file.shift.split(",")
    
        [headers, headers.each_with_index.map{|a,i| "#{a}:#{types[i]}"}]
    end
end