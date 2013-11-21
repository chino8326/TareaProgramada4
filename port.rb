# Importación de las librerías necesarias

# rubygems es una libreria para la integración de gems o plugins 
# para la implementación de funcionalidades adicionales al programa
require 'rubygems'
require 'slim'
require 'sinatra'
require 'oauth'
require 'launchy' 

# nokogiri es una librería para el uso de código HTML 

require 'nokogiri'

# open-uri es una sublibrería de nokogiri, que permite la búsqueda
# de código HTML en línea

require 'open-uri'

require 'slim'

require 'sinatra'

####################### INICIO DE IMPLEMENTACIÓN #######################

class Resultado
	
	def initialize(artist, alb, lk, ft, ct)
		@artista=artist
		@album=alb
		@link=lk
		@foto=ft
		@costo=ct
	end
	
	def getArtista
		@artista 
	end
	
	def getAlbum
		@album
	end
	
	def getLink
		@link 
	end
	
	def getFoto
		@foto
	end
	
	def getCosto
		@costo 
	end

end

# Función de búsqueda HTML

def buscarHTML(text, array)
	
	# Verifica un URL Válido por BandCamp y que el usuario haya digitado algo en el motor de búsqueda
	begin 
		#Se utiliza para cambiar los espacios del string
		#y convertirlos en un + para crear el formato
		#correcto del tag a evaluar en linea para la conexión
		#en linea con BandCamp
		
		tag = text.gsub(" ", "+") 

		if tag.eql? ""
			puts "No" 
			puts "\n"
			buscarHTML()
		else
			puts "\n"
			web = Nokogiri::HTML(open("http://bandcamp.com/search?q=" + tag))
		end
	
	# En caso de que haya un error de conexión lanzará esta advertencia	
	rescue URI::InvalidURIError => error
		puts "Hubo "
		puts "\n"
		buscarHTML()
	
	ensure	
		
		#La variable resultados es un array que contiene todos los resultados de la búsqueda HTML
		resultados = web.css("li[class='searchresult']")
		x = 0
		
		#Mediante este ciclo se obtienen los 10 resultados solicitados, o los únicos que 
		#cumplan con los criterios de búsqueda
		while (x <= 9)
			if resultados[x] == nil
				break
			else
				page = resultados[x]
				tmp1 = page.css("a")
				link = tmp1[0]["href"] #Link de Bandcamp 
				tmp2 = page.css("img") #Imagen del album
				imagen = tmp2[0]["src"]
				buscarInfo(link, imagen, x, array) #Llamada a la función para buscar información del resultado
				x = x + 1
			end			
		end
	end
	
end

def buscarInfo(html, imagen, x, array)

	web = Nokogiri::HTML(open(html))
	
	album = web.css("h2[class='trackTitle']").text #Nombre del Album
	
	grupo = web.css("span[itemprop='byArtist']").text #Nombre del Autor
	
	#Criterios de comparación para obtener su costo
	tmp1 = web.css("li[class='buyItem']") 
	tmp2 = tmp1.css("span[class='buyItemExtra buyItemNyp secondaryText']").text
	
	#Si el elemento indica "or more", tiene costo
	#Sino el elemento es gratuito
	if tmp2.match("or more") 
		monedatmp = tmp1.css("span[class='buyItemExtra secondaryText']")
		moneda = monedatmp[0].text
		preciotmp = tmp1.css("span[class='base-text-color']")
		precio = preciotmp[0].text
		costo = precio + " " + moneda
	else
		costo = "Gratis"
	end
	

	array[x] = Resultado.new(grupo.strip, album.strip, html.strip, imagen.strip, costo.strip)
	
end	

arrayResultados = Array.new(10)

get '/Index' do  
	slim :Index
end  
 
post '/' do 
	txt = params[:music]
	
	buscarHTML(txt, arrayResultados)
	
	
	publicar ( arrayResultados)
		
			
	
    
end


#def arrayblock (array)
	
		
#		rotador=0;
#		while(rotador<9)
#			musica=array[rotador]
#		
#			puts musica.getArtista
#			puts musica.getAlbum
#			puts musica.getLink 
#			puts musica.getFoto 
#			puts musica.getCosto
#		 
#			puts "\n"
#	
#			rotador=rotador+1
#		end
#	
#end	

def publicar (array)
		printed=""
		####################################################################################
		musica=array[0]
		palbotton0=""
		##############################################################################
			palbotton0="https://twitter.com/share/home?status=hola" 
			
			#palbotton0=palbotton0+ '<p>'+musica.getAlbum+'</p>'
			#palbotton0=palbotton0 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton0=palbotton0+ '<p>'+musica.getCosto+'</p>'
			#palbotton0=palbotton0+ '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a>'+'</p>'
		
		##############################################################################
			printed=printed+'<p>' +musica.getArtista+ '</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+ '<a href= '+palbotton0+' title = "CLick to send this page to Twitter!" class="twitter-share-button" data-lang="en">Tweet</a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script> '+'</p>'
		
		###############################################################################
		musica=array[1]
		palbotton1=""
		############################################################################
			#palbotton1=palbotton1+'<p>'+musica.getArtista+'</p>'
			#palbotton1=palbotton1+ '<p>'+musica.getAlbum+'</p>'
			#palbotton1=palbotton1 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton1=palbotton1+ '<p>'+musica.getCosto+'</p>'
			#palbotton1=palbotton1+ '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
		############################################################################
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'    <a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'+'</p>'
	############################################################################3	
		musica=array[2]
		palbotton2=""
	###########################################################################33
			#palbotton2=palbotton2+'<p>'+musica.getArtista+'</p>'
			#palbotton2=palbotton2+ '<p>'+musica.getAlbum+'</p>'
			#palbotton2=palbotton2 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton2=palbotton2+ '<p>'+musica.getCosto+'</p>'
			#palbotton2=palbotton2 + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
	
	##########################################################################33	
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+ '     <a href="https://twitter.com/share/" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'+'</p>'
	##########################################################################################33	
		musica=array[3]
		palbotton3=""
	#######################################################################################
			#palbotton3=palbotton3+'<p>'+musica.getArtista+'</p>'
			#palbotton3=palbotton3+ '<p>'+musica.getAlbum+'</p>'
			#palbotton3=palbotton3 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton3=palbotton3+ '<p>'+musica.getCosto+'</p>'
			#palbotton3=palbotton3 + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
	########################################################################################	
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+ '<a href="https://twitter.com/share pal" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'+'</p>'
	#######################################################################333	
		musica=array[4]
			palbotton4=""	
	############################################################33
			#palbotton4=palbotton4+'<p>'+musica.getArtista+'</p>'
			#palbotton4=palbotton4+ '<p>'+musica.getAlbum+'</p>'
			#palbotton4=palbotton4 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton4=palbotton4+ '<p>'+musica.getCosto+'</p>'
			#palbotton4=palbotton4 + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
	
	###############################################################	
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'<a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'+'</p>'
	#########################################################################3	
		musica=array[5]
			palbotton5=""	
	##############################################################
			#palbotton5=palbotton5+'<p>'+musica.getArtista+'</p>'
			#palbotton5=palbotton5+ '<p>'+musica.getAlbum+'</p>'
			#palbotton5=palbotton5 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton5=palbotton5+ '<p>'+musica.getCosto+'</p>'
			#palbotton5=palbotton5 + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
	
	##############################################################3		
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'<a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script> '+'</p>'
		#########################################################################
		musica=array[6]
		palbotton6=""	
		############################################################################
			#palbotton6=palbotton6+'<p>'+musica.getArtista+'</p>'
			#palbotton6= palbotton6 + '<p>'+musica.getAlbum+'</p>'
			#palbotton6= palbotton6 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton6= palbotton6 + '<p>'+musica.getCosto+'</p>'
			#palbotton6= palbotton6+ '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
		
		#########################################################################	
			
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'<a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script> '+'</p>'
		###############################################################################################################
		musica=array[7]
		palbotton7=""
		#########################################################################3
			#palbotton7=palbotton7+'<p>'+musica.getArtista+'</p>'
			#palbotton7= palbotton7 + '<p>'+musica.getAlbum+'</p>'
			#palbotton7= palbotton7 + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton7= palbotton7 + '<p>'+musica.getCosto+'</p>'
			#palbotton7= palbotton7+ '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
		###########################################################################3

			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'<a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'+'</p>'
############################################################################################33		
		musica=array[8]
		palbotton8=""
		###################################################
			#palbotton8=palbotton8+'<p>'+musica.getArtista+'</p>'
			#palbotton8=palbotton8+ '<p>'+musica.getAlbum+'</p>'
			#palbotton8=palbotton8+ '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton8=palbotton8+ '<p>'+musica.getCosto+'</p>'
			#palbotton8=palbotton8+ '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
		######################################################
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'    <a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script> '+'</p>'
			
	#########################################################################		
		musica=array[9]
		palbotton9=""
	############################################################
			#palbotton9=palbotton9+'<p>'+musica.getArtista+'</p>'
			#palbotton9=palbotton9+ '<p>'+musica.getAlbum+'</p>'
			#palbotton9=palbotton9+ '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			#palbotton9=palbotton9+ '<p>'+musica.getCosto+'</p>'
			#palbotton9=palbotton9+ '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
	
	###############################################################3
			printed=printed+'<p>'+musica.getArtista+'</p>'
			printed= printed + '<p>'+musica.getAlbum+'</p>'
			printed= printed + '<p>'+'<img src="'+musica.getFoto+'"alt="Cover del album">'+'</p>' 
			printed= printed + '<p>'+musica.getCosto+'</p>'
			printed= printed + '<p>'+'<a href="'+musica.getLink+'">Chequea el Album dale click</a> '+'</p>'
			printed=printed+ '<p>'+'     <a href="https://twitter.com/share" class="twitter-share-button" data-lang="en">Tweet</a>

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'+'</p>'
														
 
 return printed

end






#def tweett(access,secret)
#@cliente=Twitter::REST::Client.new do |config|
 #     config.consumer_key = 'uMQAZPz54zbrMK3VVd4Q'
  #    config.consumer_secret = '4SYicWBQnxWE0r999vMi7znekuoBMIq5pHlDQ9LyI'
   #   config.oauth_token = access
    #  config.oauth_token_secret = secret
    #end
    
#puts "Publicar un nuevo Tweet..."
#tweet= gets() #Obtenemos lo que el usuario digite

#@cliente.update(tweet)
#end

#def tweettt()
#redirect_url = "http://ubuntulinuxcr.blogspot.com"
	
#url = URI.parse(URI.encode(redirect_url.strip))
#consumer_key="uMQAZPz54zbrMK3VVd4Q"
#consumer_secret="4SYicWBQnxWE0r999vMi7znekuoBMIq5pHlDQ9LyI"
	
#consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
	                             #{ :site => "http://api.twitter.com" })
#request_token = consumer.get_request_token#(:oauth_callback => url)
#Launchy.open request_token.authorize_url
#puts "Por favor ingrese el PIN que le fue dado cuando autorizo la aplicacion"
#pincode = gets.chomp
#access_token = request_token.get_access_token :oauth_verifier => pincode
#access=access_token.token # user token
#secret=access_token.secret # user oauth secret
#puts access
#puts secret
#tweett(access,secret)
#end


