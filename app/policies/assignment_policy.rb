class AssignmentPolicy < ApplicationPolicy

  def run_tests?
    check?(:not_a_ta?) && check?(:enabled?) && check?(:test_groups_exist?) && (!user.student? ||
      (check?(:tokens_released?) && check?(:before_due_date?))
    )
  end

  def not_a_ta?
    !user.ta?
  end

  def enabled?
    record.enable_test && (!user.student? || record.enable_student_tests)
  end

  def test_groups_exist?
    record.test_groups.exists?
  end

  def tokens_released?
    Time.current >= record.token_start_date
  end

  def before_due_date?
    !record.submission_rule.can_collect_now?
  end
end
