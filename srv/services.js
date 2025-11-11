const cds = require('@sap/cds');

module.exports = class PurchaseOrder extends cds.ApplicationService {

    async init () {

        const {
            VH_Company,
            VH_PurchasingOrg,
            VH_PurchasingGroup,
            VH_PurchaseOrderType,
            VH_Supplier
        } = this.entities;

        const api_company = await cds.connect.to("API_COMPANYCODE_SRV");
        const api_purchasingorg = await cds.connect.to("CE_PURCHASINGORGANIZATION_0001");
        const api_purchasinggroup = await cds.connect.to("CE_PURCHASINGGROUP_0001");
        const api_purchaseordertype = await cds.connect.to("ZPURCHASEORDERTYPE_READ");
        const api_supplier = await cds.connect.to("API_BUSINESS_PARTNER");

        this.on('READ', VH_Company, async (req) => {
            return await api_company.tx(req).send({
                query: req.query,
                headers: {
                    Authorization: process.env.AUTHORIZATION
                }
            })
        });

        this.on('READ', VH_PurchasingOrg, async (req) => {
            return await api_purchasingorg.tx(req).send({
                query: req.query, 
                headers: {
                    apikey: process.env.APIKEY
                }
            })
        });

        this.on('READ', VH_PurchasingGroup, async (req) => {
            return await api_purchasinggroup.tx(req).send({
                query: req.query, 
                headers: {
                    apikey: process.env.APIKEY
                }
            })
        });

        this.on('READ', VH_PurchaseOrderType, async (req) => {
            return await api_purchaseordertype.tx(req).send({
                query: req.query, 
                headers: {
                    Authorization: process.env.AUTHORIZATION
                }
            })
        });

         this.on('READ', VH_Supplier, async (req) => {

            const filter = req.query.SELECT.where;
            let purchasingOrg = '';

            if (filter) {
                purchasingOrg = filter[2]?.val;
            }

            if (!purchasingOrg) {
                return [];
            }

            const supplierIdQuery = SELECT.from('API_BUSINESS_PARTNER.A_SupplierPurchasingOrg')
                                    .columns('Supplier')
                                    .where({PurchasingOrganization: purchasingOrg});

            const supplierIdResults = await api_supplier.run(supplierIdQuery);


            if (supplierIdResults.length === 0) {
                return [];
            }

            const uniqueSupplierID = [... new Set(supplierIdResults.map(s=> s.Supplier))];

            const supplierQuery = SELECT.from('API_BUSINESS_PARTNER.A_Supplier', supplier => {
                supplier.Supplier,
                supplier.SupplierName
            }).where({Supplier : { in : uniqueSupplierID}});

            const results = await api_supplier.run(supplierQuery);

            return results.map(supplier => ({
                Supplier: supplier.Supplier,
                SupplierName: supplier.SupplierName,
                PurchasingOrganization: purchasingOrg
            }));

        });

        return super.init();
    }

};