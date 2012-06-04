# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'eat'
require 'nokogiri'
require 'timeout'
require 'decimal'
#require 'httparty'


#######
# 
# juste un simple plugin calculatrice
#
#      n'oubliez pas d'ajoutez le fichier dans "/.siriproxy/config.yml"
#
#
### Contact
#
# Twitter: @gregaaronryan
# oder github.com/gregaaronryan/SiriProxy-Calc
######

class SiriProxy::Plugin::Calc < SiriProxy::Plugin
        
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    def doc
    end
    def ror
    end
    def res
    end
    def rer
    end

    def cleanup(doc)
    doc = doc.to_s
 		while doc.match(/(un)/)
 			doc = doc.sub( "un","1")
 		end
 		while doc.match(/(deux)/)
 			doc = doc.sub( "deux","2")
 		end
 		while doc.match(/(trois)/)
 			doc = doc.sub( "trois","3")
 		end
 		while doc.match(/(quatre)/)
 			doc = doc.sub( "quatre","4")
 		end
 		while doc.match(/(cinq)/)
 			doc = doc.sub( "cinq","5")
 		end
 		while doc.match(/(sisse)/)
 			doc = doc.sub( "sisse","6")
 		end
 		while doc.match(/(six)/)
 			doc = doc.sub( "six","6")
 		end
 		while doc.match(/(sept)/)
 			doc = doc.sub( "sept","7")
 		end
 		while doc.match(/(huit)/)
 			doc = doc.sub( "huit","8")
 		end
 		while doc.match(/(neuf)/)
 			doc = doc.sub( "neuf","9")
 		end
 		while doc.match(/(null)/)
 			doc = doc.sub( "null","0")
 		end
 		while doc.match(/(dix)/)
 			doc = doc.sub( "dix","10")
 		end
 		while doc.match(/( )/)
			doc = doc.sub( " ", "" )
		end
	doc = doc.sub( ".", "" )
	doc = doc.sub( ",", "." )
	doc = doc.strip
 	return doc
 	end

	def replus(re,ro,cal)
		rer = cleanup(re)
		ror = cleanup(ro)
		#rer = rerr if ( Float( rerr ) rescue false )
		#ror = rorr if ( Float( rorr ) rescue false )
		res = res.to_f
		print cal
		if cal == "+"
			res = Decimal(rer) + Decimal(ror) 
		elsif cal == "*"
			res = Decimal(rer) * Decimal(ror)
		elsif cal == "-"
			res = Decimal(rer) - Decimal(ror)
		elsif cal == "/"
			res = (rer.to_f)/(ror.to_f)
		end
		@vor = rer
		@nach = ror
		@res = res.to_s.sub( ".", "," )
		return rer,ror
	end
    
listen_for /(Combien font|Combien fait|Calcule) (.*)/i do |phrose,phrase|
	@vor = 0
	@nach = 0
	@res = 0
	ss = ""
	ph = phrase.insert(0, " ")
	ph = ph.to_s
	if phrase.match(/( plus )/) 
		ma = phrase.match(/( plus )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "+"
		replus(vor,nach,cal)
		say @vor.to_s + " + " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/( × )/)  # × not x
		ma = phrase.match(/( × )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "*"
		replus(vor,nach,cal)
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(fois )/)
		ma = phrase.match(/(fois )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "*"
		replus(vor,nach,cal)
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/( - )/)
		ma = phrase.match(/( - )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "-"
		replus(vor,nach,cal)
		say @vor.to_s + " - " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(\/)/)
		ma = phrase.match(/(\/)/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "/"
		replus(vor,nach,cal)
		say @vor.to_s + " / " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/( par )/)
		ma = phrase.match(/( par )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "/"
		replus(vor,nach,cal)
		say @vor.to_s + " / " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	else
		mh = phrase
		print "-----AHA----"
		print mh
		say "voulez vous recommencez", spoken: "je ne trouve aucun résultat?"
	end
	request_completed
end
end
