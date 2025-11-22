const cds = require('@sap/cds');
const { SELECT } = require('@sap/cds/lib/ql/cds-ql');
const moment = require('moment');

module.exports = class PurchaseOrder extends cds.ApplicationService {

    async init () {

        const {
            PurchaseOrder,
            PurchaseOrderItem,
            VH_Company,
            VH_PurchasingOrg,
            VH_PurchasingGroup,
            VH_PurchaseOrderType,
            VH_Supplier,
            VH_Plant,
            VH_StorageLocation,
            VH_Product,
            VH_InfoRecord
        } = this.entities;

        const api_company = await cds.connect.to("API_COMPANYCODE_SRV");
        const api_purchasingorg = await cds.connect.to("CE_PURCHASINGORGANIZATION_0001");
        const api_purchasinggroup = await cds.connect.to("CE_PURCHASINGGROUP_0001");
        const api_purchaseordertype = await cds.connect.to("ZPURCHASEORDERTYPE_READ");
        const api_supplier = await cds.connect.to("API_BUSINESS_PARTNER");
        const api_plant = await cds.connect.to("API_PLANT_SRV");
        const api_storagelocation = await cds.connect.to("API_STORAGELOCATION_SRV");
        const api_product = await cds.connect.to("API_PRODUCT_SRV");
        const api_inforecord = await cds.connect.to("API_INFORECORD_PROCESS_SRV");

        /**
         * Custom Logic
         */

        //CREATE (NEW), UPDATE, DELETE, READ
        //before,on,after

        this.before('NEW', PurchaseOrder.drafts, async (req) => {
            const pop = await SELECT.one.from(PurchaseOrder).columns('max(PurchaseOrder)');
            const pod = await SELECT.one.from(PurchaseOrder.drafts).columns('max(PurchaseOrder)');

            let ipop = parseInt(pop.max);
            let ipod = parseInt(pod.max);
            let iNewMax = 0;

            if (isNaN(ipod)) {
                iNewMax = ipop + 1;
            } else if (ipod > ipop) {
                iNewMax = ipod + 1;
            } else {
                iNewMax = ipop + 1;
            }

            req.data.PurchaseOrder = String(iNewMax);

            //Field - Date
            req.data.PurchaseOrderDate = moment().format("YYYY-MM-DD");
        });

        this.before('NEW', PurchaseOrderItem.drafts, async (req) => {
            let parentId = req.data.PurchaseOrder_ID;

            let {max} = await SELECT.one.from(PurchaseOrderItem.drafts).
                                columns('max(PurchaseOrderItem)')
                                .where({PurchaseOrder_ID: parentId});
            const newItem = (parseInt(max?? 0)) + 10;   //10 --> 00010

            req.data.PurchaseOrderItem = String(newItem).padStart(5,'0');
        });

        this.before('PATCH', PurchaseOrderItem.drafts, async (req) => {
            

            if (req.data.Material_Product && req.data.MaterialName) {

                let parentId = req.data.PurchaseOrder_ID;
                let itemId = req.data.ID;

                const result = await SELECT.one.from(PurchaseOrderItem.drafts)
                                .columns(i=> {
                                    i.Material_Product,
                                    i.Plant_Plant,
                                    i.PurchaseOrder (p => {
                                        p.Supplier_Supplier,
                                        p.PurchasingOrganization_PurchasingOrganization
                                    })
                                })
                                .where({ID: itemId, PurchaseOrder_ID: parentId});

                let material = result.Material_Product;
                let plant = result.Plant_Plant;
                let supplier = result.PurchaseOrder.Supplier_Supplier;
                let PurchasingOrg = result.PurchaseOrder.PurchasingOrganization_PurchasingOrganization;

                if (!material || !plant || !supplier || !PurchasingOrg) {
                    console.log("Algunos de los campos estan vacios");
                    return;
                }
                
                const query = SELECT.one.from("API_INFORECORD_PROCESS_SRV.A_PurgInfoRecdOrgPlantData")
                                .columns(
                                    'MinimumPurchaseOrderQuantity',
                                    'MaximumOrderQuantity',
                                    'NetPriceAmount',
                                    'PurchaseOrderPriceUnit',
                                    'MaterialPriceUnitQty',
                                    'Currency',
                                    'TaxCode',
                                    'PurchasingInfoRecord'
                                )
                                .where({
                                    PurchasingOrganization: PurchasingOrg,
                                    Supplier: supplier,
                                    Plant: plant,
                                    Material: material
                                });
                
                try {
                    const infoRecord = await api_inforecord.run(query);
                    console.log(infoRecord);

                    if (infoRecord) {
                        await UPDATE.entity(PurchaseOrderItem.drafts).set({
                            NetPriceAmount: infoRecord.NetPriceAmount,
                            DocumentCurrency_code: infoRecord.Currency,
                            NetPriceQuantity: infoRecord.MaterialPriceUnitQty,
                            PurchaseOrderQuantityUnit_BaseUnit: infoRecord.PurchaseOrderPriceUnit,
                            OrderPriceUnit_BaseUnit: infoRecord.PurchaseOrderPriceUnit,
                            TaxCode: infoRecord.TaxCode,
                            PurchasingInfoRecord: infoRecord.PurchasingInfoRecord
                        }).where({
                            ID: itemId,
                            PurchaseOrder_ID: parentId
                        });
                    } else {
                        await UPDATE.entity(PurchaseOrderItem.drafts).set({
                            NetPriceAmount: '',
                            DocumentCurrency_code: '',
                            NetPriceQuantity: '',
                            PurchaseOrderQuantityUnit_BaseUnit: '',
                            OrderPriceUnit_BaseUnit: '',
                            TaxCode: '',
                            PurchasingInfoRecord: ''
                        }).where({
                            ID: itemId,
                            PurchaseOrder_ID: parentId
                        });
                    }

                } catch (error) {  
                    console.log("Ocurrió un error durante la consulta");
                }

            }

        });

        /**
         * Value Helps
         */

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

        this.on('READ', VH_Plant, async (req) => {
            return await api_plant.tx(req).send({
                query: req.query, 
                headers: {
                    Authorization: process.env.AUTHORIZATION
                }
            })
        });

        this.on('READ', VH_StorageLocation, async (req) => {
            return await api_storagelocation.tx(req).send({
                query: req.query, 
                headers: {
                    Authorization: process.env.AUTHORIZATION
                }
            })
        });

        this.on('READ', VH_Product, async (req) => {
            const filter = req.query.SELECT.where;
            let plant = '';

            if (filter) {
                plant = filter[2].val;
            }

            if (!plant) {
                return [];
            }

            // Recuperar todos los códigos de los productos que estan relacionados con al centro (Plant). 
            // En este ejemplo hacemos referencia al centro (Plant) 1010
            const productQuery = SELECT.from("API_PRODUCT_SRV.A_ProductPlant")
                                        .columns('Product')
                                        .where({Plant: plant});

            const products = await api_product.run(productQuery);
            
            if (products.length === 0) {
                return [];
            }

            const ids = [...new Set(products.map(p => p.Product))];
            //const ids = ['TG10','TG11','TG12'];
            console.log(ids);

            const chunkSize = 10;
            const promises = [];

            for (let i = 0; i < ids.length; i += chunkSize) {
                const chunk = ids.slice(i, i + chunkSize);
                const query = SELECT.from('API_PRODUCT_SRV.A_Product')
                                    .columns(p => {
                                        p.Product,
                                        p.ProductGroup,
                                        p.ProductType,
                                        p.BaseUnit,
                                        p.to_Description( d => {
                                            d.ProductDescription
                                        }).where({Language: req.user.locale?? 'EN'}),
                                        p.to_ProductProcurement(pd => {
                                            pd.PurchaseOrderQuantityUnit
                                        })
                                    }).where({Product: {in: chunk}});

                promises.push(api_product.run(query));
            }

            const chunkResults = await Promise.all(promises);
            const aProducts = chunkResults.flat();

            return aProducts.map(item => ({
                Product: item.Product,
                ProductName: item.to_Description[0]?.ProductDescription || 'No Description',
                ProductGroup: item.ProductGroup,
                ProductType: item.ProductType,
                BaseUnit: item.BaseUnit??item.to_ProductProcurement?.PurchaseOrderQuantityUnit,
                Plant: plant
            }))

        });

        this.on('READ', VH_InfoRecord, async (req) => {
            return await api_inforecord.tx(req).send({
                query: req.query
            })
        });

        return super.init();
    }

};