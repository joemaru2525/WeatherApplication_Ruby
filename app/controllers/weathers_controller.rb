class WeathersController < ApplicationController
  def index
  end

  def show  
    require 'nokogiri'
    require 'open-uri'

    url = 'https://weather.yahoo.co.jp/weather/jp/14/4610.html'

    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # ノコギリを使ってhtmlを解析
    doc = Nokogiri::HTML.parse(html, charset)
    
    # site title
    @title = doc.at('title').inner_text
    
    # announce date & time
    str = doc.css('p.yjSt,yjw_note_h2').inner_text
    pos = str.index("発表")
    len = pos + 2
    newStr = str[0, len]
    @announce = newStr
        
    #date of weather forcast
    @weatherdate = doc.at('div.forecastCity').at('p.date').inner_text   
        
    #weather forecast
    @weatherforecast = doc.search( 'div.forecastCity>table> tr> td> div>p.pict' ).inner_text[0]
    
    #weather image
    @weatherimage = doc.search( 'div.forecastCity>table> tr> td> div>p.pict>img' )[0].attribute("src").value    
    
    #high temp
    str =  doc.search( 'div.forecastCity>table> tr> td> div>ul.temp>li.high' ).inner_text
    pos = str.index("]") 
    len = pos + 1
    newStr = str[0, len]    
    @hightemp = newStr 
     
    #low temp
    str =  doc.search( 'div.forecastCity>table> tr> td> div>ul.temp>li.low' ).inner_text
    pos = str.index("]") 
    len = pos + 1
    newStr = str[0, len]      
    @lowtemp = newStr    
    
    #precip1
    str =  doc.search( 'div.forecastCity>table> tr> td> div>table>tr.precip>td' )
    str1 =  str.inner_text
    @str1 = str1
    
    @precip1 =  str[0].inner_text
    @precip2 =  str[1].inner_text    
    @precip3 =  str[2].inner_text    
    @precip4 =  str[3].inner_text
  end
end
