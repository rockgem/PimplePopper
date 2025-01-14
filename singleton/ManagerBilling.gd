extends Node


var payment

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		
		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		
		payment.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")


func _on_connected():
  payment.querySkuDetails(["my_iap_item"], "inapp") # "subs" for subscriptions


func _on_sku_details_query_completed(sku_details):
	for available_sku in sku_details:
		print(available_sku)


func _on_purchases_updated(purchases):
	for purchase in purchases:
		if purchase.purchase_state == 1: 
			if not purchase.is_acknowledged:
				payment.acknowledgePurchase(purchase.purchase_token)
				# you need to setup your game's in-app-items
				# and put them in this array
				if purchase.sku in []:
					payment.consumePurchase(purchase.purchase_token)










