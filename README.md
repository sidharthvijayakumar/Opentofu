# Opentofu
#This appies the Open policy agent module
tofu apply -target=module.open-policy-agent --auto-approve

#This applies the Open policy agenet templates
tofu apply -target=module.opa-templates --auto-approve

#This applies the Open policy agent contraints and other modules
tofu apply --auto-approve