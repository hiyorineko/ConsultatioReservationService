class ReserveRegisterMailer < ApplicationMailer
  def send_reserve_complete_email_to_user(reserve, user, expert, expert_type)
    @reserve = reserve
    @expert = expert
    @expert_type = expert_type
    mail( :to => user.email,
          :subject => '予約登録完了のお知らせ' )
  end
  def send_reserve_cancel_email_to_user(reserve, user, expert, expert_type)
    @reserve = reserve
    @expert = expert
    @expert_type = expert_type
    mail( :to => user.email,
          :subject => '予約キャンセルのお知らせ' )
  end
  def send_reserve_complete_email_to_expert(reserve, user, expert_type)
    @reserve = reserve
    @user = user
    @expert_type = expert_type
    mail( :to => reserve.expert.email,
          :subject => '予約登録完了のお知らせ' )
  end
  def send_reserve_cancel_email_to_expert(reserve, user, expert_type)
    @reserve = reserve
    @user = user
    @expert_type = expert_type
    mail( :to => reserve.expert.email,
          :subject => '予約キャンセルのお知らせ' )
  end
end
