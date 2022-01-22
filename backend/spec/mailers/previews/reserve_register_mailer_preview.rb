# Preview all emails at http://localhost:3000/rails/mailers/reserve_register_mailer
class ReserveRegisterMailerPreview < ActionMailer::Preview
  def send_reserve_complete_email_to_user
    reserve = FactoryBot.create(:reserve, start_at: '2022-1-21 12:00'.to_time)
    ReserveRegisterMailer.send_reserve_complete_email_to_user(
      reserve,
      reserve.user,
      reserve.expert,
      reserve.expert.expert_type
      )
  end
  def send_reserve_cancel_email_to_user
    reserve = FactoryBot.create(:reserve, start_at: '2022-1-21 12:00'.to_time)
    ReserveRegisterMailer.send_reserve_cancel_email_to_user(
      reserve,
      reserve.user,
      reserve.expert,
      reserve.expert.expert_type
    )
  end
  def send_reserve_complete_email_to_expert
    reserve = FactoryBot.create(:reserve, start_at: '2022-1-21 12:00'.to_time)
    ReserveRegisterMailer.send_reserve_complete_email_to_expert(
      reserve,
      reserve.user,
      reserve.expert
    )
  end
  def send_reserve_cancel_email_to_expert
    reserve = FactoryBot.create(:reserve, start_at: '2022-1-21 12:00'.to_time)
    ReserveRegisterMailer.send_reserve_cancel_email_to_expert(
      reserve,
      reserve.user,
      reserve.expert
    )
  end
end
