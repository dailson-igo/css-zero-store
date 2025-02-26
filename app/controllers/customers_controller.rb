class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]
  LIMIT_PER_PAGE = [ 10, 20, 30, 40, 50, 100 ].freeze
  def index
    per_page = if params[:limit].present? && LIMIT_PER_PAGE.include?(params[:limit].to_i)
      params[:limit].to_i
    else
      10 # valor padrão
    end

    @search = Customer.all.ransack(params[:q])
    @pagy, @customers = pagy(@search.result, limit: per_page)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        flash.now[:notice] = "Cliente salvo com sucesso!"

        format.html { redirect_to @customer }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash")
          ]
        end
      else
        flash.now[:alert] = "Houve um erro ao salvar o cliente."

        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flash",
                                                    partial: "shared/flash")
        end
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

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("#{helpers.custom_dom_id(@customer)}")
        # <turbo-stream action="remove" target="<%= custom_dom_id(@customer) %>"></turbo-stream>
        # turbo_stream.update("customers_count", Customer.count),
      ]
      end
      format.html { redirect_to customers_path, notice: "Cliente excluído." }
    end
  end

  private

  def set_customer
    # @customer = Customer.find(params[:id])
    @customer = Customer.find_by_sqid(params[:id])
  end

  def customer_params
    params.expect(customer: %i[first_name last_name email phone country])
  end
end
