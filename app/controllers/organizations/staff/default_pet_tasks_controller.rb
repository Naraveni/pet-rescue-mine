class Organizations::Staff::DefaultPetTasksController < Organizations::BaseController
  before_action :context_authorize!, only: %i[index new create]
  before_action :set_task, only: %i[edit update destroy]

  layout "dashboard"

  def index
    @default_pet_tasks = authorized_scope(DefaultPetTask.all).sort_by { |task| task.species }
  end

  def new
    @task = DefaultPetTask.new
  end

  def create
    @task = DefaultPetTask.new(task_params)

    if @task.save
      redirect_to staff_default_pet_tasks_path, notice: t(".success")
    else
      flash.now[:alert] = t(".error")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to staff_default_pet_tasks_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to staff_default_pet_tasks_path, notice: t(".success")
  end

  private

  def task_params
    params.require(:default_pet_task).permit(:name, :description, :due_in_days, :species, :recurring)
  end

  def set_task
    @task = DefaultPetTask.find(params[:id])

    authorize! @task
  rescue ActiveRecord::RecordNotFound
    redirect_to staff_default_pet_tasks_path, alert: t(".error")
  end

  def context_authorize!
    authorize! DefaultPetTask,
      context: {organization: Current.organization}
  end
end
