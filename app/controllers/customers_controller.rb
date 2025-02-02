class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy ]
  def index
    per_page = params[:items].present? ? params[:items].to_i : 10
    @pagy, @customers = pagy(Customer.all, limit: per_page)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    # if @customer.save
    #   redirect_to @customer
    # else
    #   render :new, status: :unprocessable_entity
    # end

    respond_to do |format|
      if @customer.save
        flash.now[:notice] = "Cliente salvo com sucesso!"

        format.html { redirect_to @customer }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("flash",
            partial: "shared/flash")
        }
      else
        flash.now[:alert] = "Houve um erro ao salvar o cliente."

        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("flash",
            partial: "shared/flash")
        }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    # redirect_to customers_path

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@customer) # Ex.: remove da lista
      end
      format.html { redirect_to customers_path, notice: "Cliente excluído." }
    end

    #
    # respond_to do |format|
    #   # Quando o usuário clica no link "Excluir" pela primeira vez
    #   format.turbo_stream {
    #     render partial: "shared/confirm_modal",
    #       locals: { url: customer_path(@customer) }
    #   }

    #   # Quando o usuário confirma a exclusão
    #   format.html {
    #     @customer.destroy
    #     redirect_to customer_path,
    #       notice: "Usuário foi excluído com sucesso."
    #   }
    # end
  end

private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.expect(customer: [ :first_name, :last_name, :email, :phone, :country ])
  end
end
