class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:payment_return]

  def direct_charge
		response = MoIP.authorize({
			:reason => "Pedido #{@order.number}",
			:id => "R#{rand(1000)}",
			:value => rand(10...15000),
			:domain => 'domain.com',
			:forma_entrega => 'Sedex',
			:pagador => {:nome => "User Name", :email => "User Email", :login => "User Login", :logradouro => "RUA das Casas", :numero => "123", :complemento => "Bloco 2", :bairro => "Bairro das Ruas", :cidade => "Cidade Grande", :cep => "00000-000", :telefone => "(51)5555-5555"}
			})
			if response["Status"] == "Sucesso"
				redirect_to MoIP.charge_url(response["Token"])
#			elsif response["Erro"] == "Id Próprio já foi utilizado em outra Instrução"
#				redirect_to MoIP.charge_url(@order.token) #assuming you are storing the token inside the Order table
			else
				render :text => response["Erro"], :status => 503
			end
  end

  def manual_charge
    @response = Moip.authorize({
     :reason => "Mensalidade",
     :id => "Pag#{rand(1000)}",
     :value => 1,
     :domain => request.domain
    })
  end

  def payment_return
    notification = MoIP.notification(params)
#		@nasp = Nasp.new(notification) 
#		@order = Order.find_by_number(params[:id_transacao]) #if using friendly-id which I recommend 
#		if @order.nil?
#			render :text => "error", :status => 503
#		else
#			@nasp.order_id = @order.id
#			@nasp.hash = @order.number + notification[:status_pagamento]
#			if @nasp.save
#				if (@nasp.valor == @order.valor )
#					logger.info { notification.to_yaml }
#					render :text => "Status changed", :status => 200
#				else
#					render :text => "error fake nasp", :status => 503
#				end
#			else
#				render :text => "error couldn't save nasp", :status => 503
#			end
#		end
		logger.info { notification.to_yaml } #should not be implemeted without checking everything 
		render :text => "Status changed", :status => 200 #at all

end