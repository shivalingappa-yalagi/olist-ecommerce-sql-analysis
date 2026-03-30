\# Data Dictionary – Olist E-Commerce Dataset



This document describes the key tables and fields used in the Olist Marketplace Data Analysis project.



---



\# 1. customers



Customer information and geographic location.



| Column | Description |

|------|-------------|

customer\_id | Unique identifier for each customer |

customer\_unique\_id | Unique identifier for a customer across multiple purchases |

customer\_zip\_code\_prefix | ZIP code prefix of the customer |

customer\_city | Customer city |

customer\_state | Customer state |



---



\# 2. orders



Contains order lifecycle timestamps and status.



| Column | Description |

|------|-------------|

order\_id | Unique order identifier |

customer\_id | Customer who placed the order |

order\_status | Order status (delivered, shipped, canceled, etc.) |

order\_purchase\_timestamp | Time when the order was placed |

order\_approved\_at | Time when payment was approved |

order\_delivered\_carrier\_date | Date when order was handed to carrier |

order\_delivered\_customer\_date | Date when order was delivered |

order\_estimated\_delivery\_date | Estimated delivery date |



---



\# 3. order\_items



Contains item-level details for each order.



| Column | Description |

|------|-------------|

order\_id | Order identifier |

order\_item\_id | Item number within the order |

product\_id | Product identifier |

seller\_id | Seller responsible for the item |

shipping\_limit\_date | Shipping deadline |

price | Product price |

freight\_value | Shipping cost |



---



\# 4. order\_payments



Payment details for each order.



| Column | Description |

|------|-------------|

order\_id | Order identifier |

payment\_sequential | Payment sequence number |

payment\_type | Payment method (credit card, boleto, voucher, etc.) |

payment\_installments | Number of installments |

payment\_value | Payment amount |



---



\# 5. order\_reviews



Customer review and rating data.



| Column | Description |

|------|-------------|

review\_id | Unique review identifier |

order\_id | Associated order |

review\_score | Rating score (1–5) |

review\_comment\_title | Review title |

review\_comment\_message | Review message |

review\_creation\_date | Date when review was created |

review\_answer\_timestamp | Seller response timestamp |



---



\# 6. products



Product catalog details.



| Column | Description |

|------|-------------|

product\_id | Unique product identifier |

product\_category\_name | Product category (Portuguese) |

product\_name\_length | Length of product name |

product\_description\_length | Length of description |

product\_photos\_qty | Number of photos |

product\_weight\_g | Product weight |

product\_length\_cm | Product length |

product\_height\_cm | Product height |

product\_width\_cm | Product width |



---



\# 7. sellers



Seller information.



| Column | Description |

|------|-------------|

seller\_id | Unique seller identifier |

seller\_zip\_code\_prefix | Seller ZIP code prefix |

seller\_city | Seller city |

seller\_state | Seller state |



---



\# 8. geolocation



Geographic mapping of ZIP codes.



| Column | Description |

|------|-------------|

geolocation\_zip\_code\_prefix | ZIP code prefix |

geolocation\_lat | Latitude |

geolocation\_lng | Longitude |

geolocation\_city | City |

geolocation\_state | State |



---



\# 9. product\_category\_name\_translation



Maps Portuguese product categories to English.



| Column | Description |

|------|-------------|

product\_category\_name | Category name in Portuguese |

product\_category\_name\_english | Category name in English |



---



\# Notes



The dataset originates from the \*\*Brazilian E-commerce Public Dataset by Olist\*\*, available on Kaggle.

