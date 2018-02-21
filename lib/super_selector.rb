require "bundler/setup"
require_relative "../bin/environment"

class Super
    attr_reader :name, :gen_info, :studio
    @@path = "http://superheroes.wikia.com/wiki"
    def initialize(name)
        @name = name.downcase.titleize!
        self.studio_check
        return @name = false if @studio == nil
        @gen_info = self.gen_info
    end
    
    def self.m_lister
        @@m_list = []
        doc = Nokogiri::HTML(open("#{@@path}/List_of_Marvel_Characters")).css("#mw-content-text li a")
        doc.each {|x| @@m_list << x.text}
        no_info = doc.map {|x| x.text if x.attr("href").include?("?") == true}
        no_info.delete(nil)
        @@m_list.reject! {|x| no_info.include? x}
        return @@m_list
    end
    
    def self.dc_lister
        @@dc_list = []
        doc = Nokogiri::HTML(open("#{@@path}/List_of_DC_Characters")).css("#mw-content-text li a")
        doc.each {|x| @@dc_list << x.text}
        no_info = doc.map {|x| x.text if x.attr("href").include?("?") == true}
        no_info.delete(nil)
        @@dc_list.reject! {|x| no_info.include? x}
        @@dc_list.each {|x| x.gsub!(/ \(.+\)/, "")}
        return @@dc_list
    end
    
    @@m_list = Super.m_lister
    @@dc_list = Super.dc_lister

    def self.m_list
        @@m_list
    end
    
    def self.dc_list
        @@dc_list
    end

    def studio_check
        i = 0
        while i < 2
            if @@m_list.include?(@name)
                puts "Marvel character"
                return @studio = "Marvel"
            elsif @@dc_list.include?(@name)
                puts "DC character"
                return @studio = "DC"
            else
                if @name.include?("The ")
                    @name.gsub!("The ", "")
                    i += 1
                else
                    @name = "The " + @name
                    i += 1
                end
            end
        end
    end
    
    def gen_info
        s_param = @name.gsub(" ", "_")
        doc = Nokogiri::HTML(open("#{@@path}/#{s_param}")).css("#mw-content-text p")
        @gen_info = doc.text.delete("\n")
    end
end

