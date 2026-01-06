az monitor log-analytics workspace list \
        --query "[].{Name:name, ResourceGroup:resourceGroup, DailyQuotaGB:workspaceCapping.dailyQuotaGb}" \
        --output table
