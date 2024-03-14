class EmployeesController < ApplicationController
	before_action :set_employee, only: [:show, :tax_deductions]

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def show
  	render json: @employee
  end

  def tax_deductions
  	financial_year_start, financial_year_end = financial_year_dates
    total_salary = calculate_total_salary(financial_year_start, financial_year_end)
    tax, cess = calculate_tax_and_cess(total_salary)
      
    data = {

        employee_id: @employee.id,
        first_name: @employee.first_name,
        last_name: @employee.last_name,
        yearly_salary: total_salary,
        tax_amount: tax,
        cess_amount: cess
     }

    render json: data
  end

  private
    
    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :email, :doj, :salary, phone_number:[])
    end
    
    def calculate_total_salary(start_date, end_date)    
     
      total_months = ((end_date - start_date).to_i / 30.0).round
      total_salary = @employee.salary * total_months
      total_salary
    end

  def calculate_tax_and_cess(salary)
    tax = 0
    cess = 0
    if salary > 250000 && salary <= 500000
      tax = (salary - 250000) * 0.05
    elsif salary > 500000 && salary <= 1000000
      tax = (250000 * 0.05) + ((salary - 500000) * 0.1)
    elsif salary > 1000000
      tax = (250000 * 0.05) + (500000 * 0.1) + ((salary - 1000000) * 0.2)
    end

    if salary > 2500000
      cess = (salary - 2500000) * 0.02
    end

    [tax, cess]
  end

  def set_employee
  	@employee = Employee.find_by_id(params[:id]) 
  end

  def financial_year_dates
    today = @employee.doj
    financial_year_start = (today.month >= 4) ? Date.new(today.year, 4, 1) : today
    financial_year_end = (today.month >= 4) ? Date.new(today.year + 1, 3, 31) : Date.new(today.year, 3, 31)
    [financial_year_start, financial_year_end]
  end

end
