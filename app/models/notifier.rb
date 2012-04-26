class Notifier < ActionMailer::Base

  default :from => "caelum.online.key.sender@gmail.com"
  
  def envia_email_acabando_chaves(chaves_restantes)
  	@chaves_restantes = chaves_restantes
    mail( :subject => "Esta acabando o numero de chaves da Amazon",
          :to => ["guilherme.silveira@caelum.com.br", "mauricio.aniche@caelum.com.br"].join(",")
    )
  end

end
