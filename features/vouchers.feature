Feature:
  As a price-conscious user
  I want to be able to redeem a voucher
  So that I can get a discount

  @javascript
  Scenario:
    Given I have added products to my cart
    When I apply a valid voucher
    Then I can view the discounted total price of my products
      And I can see how much I have saved

  @javascript
  Scenario:
    Given I have added products to my cart
    When I apply a invalid voucher
    Then I will receive an alert that my voucher is invalid

