require 'nokogiri'
require 'open-uri'
require 'csv'

class Specs
	attr_reader :store, :sku, :pn, :url

  def initialize(store, sku, pn, url)
		@store = store
		@sku = sku
		@pn = pn
		@url = url
	end

  def parser
    @parser ||= Nokogiri::HTML(open(url, 'User-Agent' => 'chrome'))
  end

  def display_size
    begin
      display_size_lookup
    rescue => e
      "display_size error: #{e}"
    else
      display_size_lookup
    end
  end

  def display_resolution
    begin
      display_resolution_lookup
    rescue => e
      "display_resolution error: #{e}"
    else
      display_resolution_lookup
    end
  end

   def touchscreen
    begin
      touchscreen_lookup
    rescue => e
      "touchscreen error: #{e}"
    else
      touchscreen_lookup
    end
  end

  def processor_brand
    begin
      processor_brand_lookup
    rescue => e
      "processor_brand error: #{e}"
    else
      processor_brand_lookup
    end
  end

   def processor_family
    begin
      processor_family_lookup
    rescue => e
      "processor_family error: #{e}"
    else
      processor_family_lookup
    end
  end

   def processor_model
    begin
      processor_model_lookup
    rescue => e
      "processor_model error: #{e}"
    else
      processor_model_lookup
    end
  end

   def processor_speed
    begin
      processor_speed_lookup
    rescue => e
      "processor_speed error: #{e}"
    else
      processor_speed_lookup
    end
  end

   def operating_system
    begin
      operating_system_lookup
    rescue => e
      "operating_system error: #{e}"
    else
      operating_system_lookup
    end
  end

     def storage_capacity
    begin
      storage_capacity_lookup
    rescue => e
      "storage_capacity error: #{e}"
    else
      storage_capacity_lookup
    end
  end

     def std_ram
    begin
      std_ram_lookup
    rescue => e
      "std_ram error: #{e}"
    else
      std_ram_lookup
    end
  end


  private
  def display_size_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributediagonal_screen_sizekey')[0].text.match(/[\d.]+/)
    end
  end

  def display_resolution_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributescreen_resolutionkey')[0].text.strip.gsub(" ","")
    end
  end

  def touchscreen_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributetouchscreenkey')[0].text.strip
    end
  end

  def processor_brand_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributeprocessor_brandkey')[0].text.strip
    end
  end

  def processor_family_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributeprocessor_typekey')[0].text.strip
    end
  end

  def processor_model_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributeprocessor_modelkey')[0].text.strip
    end
  end

  def processor_speed_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributeprocessor_speedkey')[0].text.match(/[\d.]+/)
    end
  end

  def operating_system_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributeoperating_systemskey')[0].text.match(/[\d.]+/)
    end
  end

  def storage_capacity_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributehard_drive_capacitykey')[0].text.match(/[\d.]+/)
    end
  end

  def std_ram_lookup
    case store.downcase
    when 'office depot'
      parser.css('#attributestandard_memorykey')[0].text.match(/[\d.]+/)
    end
  end
end


contents = CSV.open "specs_lookup-input.csv", headers: true, header_converters: :symbol
contents.each do |row|

  product = Specs.new(row[:store], row[:sku], row[:pn], row[:url])

  puts product.store, product.sku, product.pn, product.url, product.display_size, product.display_resolution, product.touchscreen, product.processor_brand, product.processor_family, product.processor_model, product.processor_speed, product.operating_system, product.storage_capacity, product.std_ram

  CSV.open("specs_lookup-output.csv", 'a+', headers: true, header_converters: :symbol) do |in_file|
    in_file << [product.store, product.sku, product.pn, product.url, product.display_size, product.display_resolution, product.touchscreen, product.processor_brand, product.processor_family, product.processor_model, product.processor_speed, product.operating_system, product.storage_capacity, product.std_ram]
  end
end