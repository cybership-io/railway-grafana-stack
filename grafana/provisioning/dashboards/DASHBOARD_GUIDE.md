# Grafana Dashboards Guide

This document explains each dashboard in the Cybership monitoring stack, what metrics they track, and how to interpret the data.

## Dashboard Overview

| Dashboard                  | Purpose                            | Primary Use Case                                               |
| -------------------------- | ---------------------------------- | -------------------------------------------------------------- |
| **App Overview**           | Application health and performance | Monitor server availability, request rates, and response times |
| **Business Metrics**       | Business KPIs and operations       | Track orders, products, fulfillments, and shipping labels      |
| **Queue Metrics**          | Background job processing          | Monitor Bull queue performance and job processing              |
| **Integration Metrics**    | External API performance           | Track API calls to shipping providers and other services       |
| **Database Metrics**       | Database performance               | Monitor PostgreSQL query performance and errors                |
| **Shipping Observability** | Shipping operations tracing        | Deep dive into shipping label purchases and carrier operations |

---

## 1. App Overview Dashboard

### Purpose

Provides a high-level view of application health and performance metrics.

### Key Metrics

- **Server Availability**: Whether the server is up and responding
- **Request Rate**: Number of HTTP requests per second
- **Response Time**: Average response time for HTTP requests
- **Error Rate**: Percentage of failed requests
- **Memory Usage**: Application memory consumption
- **CPU Usage**: Application CPU utilization

### Important Labels

- `job`: Prometheus job name (e.g., "server")
- `instance`: Server instance identifier
- `status_code`: HTTP status codes (200, 404, 500, etc.)
- `method`: HTTP methods (GET, POST, PUT, DELETE)
- `route`: API endpoint paths

### When to Use

- Daily health checks
- Identifying performance degradation
- Monitoring during deployments
- Alerting on service availability

### Key Indicators

- ✅ **Healthy**: Availability > 99%, Response time < 500ms
- ⚠️ **Warning**: Availability 95-99%, Response time 500ms-2s
- ❌ **Critical**: Availability < 95%, Response time > 2s

---

## 2. Business Metrics Dashboard

### Purpose

Tracks key business operations and KPIs to understand application usage and business performance.

### Key Metrics

- **Orders Processed**: Number of orders imported/processed per hour
- **Products Updated**: Product catalog changes and updates
- **Products Created**: New products added to the system
- **Fulfillments Created**: Shipping fulfillments generated
- **Shipping Labels Purchased**: Labels bought from carriers
- **Handler Executions**: API handler performance and success rates

### Important Labels

- `shop_name`: Store/shop identifier
- `shop_type`: E-commerce platform (shopify, woocommerce, magento2, etc.)
- `fulfillment_status`: success/failed
- `carrier`: Shipping carrier (usps, fedex, ups, etc.)
- `service_type`: Shipping service (priority, ground, express, etc.)
- `operation_id`: Specific business operation identifier
- `caller_type`: API caller type (user, api_key)

### When to Use

- Understanding business growth and trends
- Identifying peak usage periods
- Monitoring integration health
- Tracking conversion rates and success metrics

### Key Indicators

- **Order Processing**: Higher rates indicate business growth
- **Success Rates**: Should be >95% for healthy operations
- **Carrier Distribution**: Shows shipping provider usage
- **Handler Performance**: Tracks API operation success

---

## 3. Queue Metrics Dashboard

### Purpose

Monitors Bull queue performance for background job processing.

### Key Metrics

- **Active Jobs**: Currently processing jobs by queue
- **Completed Jobs**: Successfully finished jobs (success/failed)
- **Job Duration**: Time taken to process jobs
- **Queue Throughput**: Jobs processed per second
- **Failed Jobs**: Jobs that encountered errors
- **Queue Backlog**: Pending jobs waiting to be processed

### Important Labels

- `queue_name`: Name of the Bull queue
  - `shopify-sync`: Shopify data synchronization
  - `order-processing`: Order fulfillment processing
  - `inventory-sync`: Inventory updates
  - `webhook-processing`: Webhook event handling
  - `email-notifications`: Email sending
  - `report-generation`: Report creation
- `status`: Job completion status (success/failed)

### When to Use

- Monitoring background job health
- Identifying queue bottlenecks
- Scaling worker processes
- Debugging failed job patterns

### Key Indicators

- ✅ **Healthy**: Active jobs < 100, Success rate > 95%
- ⚠️ **Warning**: Active jobs 100-500, Success rate 90-95%
- ❌ **Critical**: Active jobs > 500, Success rate < 90%

### Queue Types Explained

- **Sync Queues**: Data synchronization between platforms
- **Processing Queues**: Order and fulfillment processing
- **Notification Queues**: Email and webhook notifications
- **Reporting Queues**: Analytics and report generation

---

## 4. Integration Metrics Dashboard

### Purpose

Tracks performance and reliability of external API integrations.

### Key Metrics

- **API Call Duration**: Response time for external API calls
- **API Error Rate**: Failed API calls by integration
- **Request Volume**: Number of API calls per integration
- **Error Categories**: Types of errors encountered
- **Response Time Distribution**: Percentile analysis of API performance

### Important Labels

- `integration`: External service name
  - `easypost`: EasyPost shipping API
  - `shipstation`: ShipStation API
  - `usps`: USPS shipping API
  - `shopify`: Shopify API
  - `woocommerce`: WooCommerce API
  - `magento2`: Magento 2 API
- `operation_type`: Specific API operation
  - `create_shipment`: Creating shipping labels
  - `get_rates`: Getting shipping rates
  - `track_package`: Package tracking
  - `sync_orders`: Order synchronization
  - `sync_products`: Product synchronization
- `error_category`: Error classification
  - `client_error`: 4xx HTTP errors
  - `server_error`: 5xx HTTP errors
  - `connection`: Network/timeout errors
  - `request_error`: Malformed requests

### When to Use

- Monitoring external service health
- Identifying integration bottlenecks
- Planning API rate limit strategies
- Debugging integration failures

### Key Indicators

- ✅ **Healthy**: Response time < 2s, Error rate < 5%
- ⚠️ **Warning**: Response time 2-5s, Error rate 5-15%
- ❌ **Critical**: Response time > 5s, Error rate > 15%

---

## 5. Database Metrics Dashboard

### Purpose

Monitors PostgreSQL database performance and query optimization.

### Key Metrics

- **Query Duration**: Average time for database operations
- **Query Volume**: Number of database queries per second
- **Connection Pool**: Database connection usage
- **Slow Queries**: Queries taking longer than expected
- **Database Errors**: Failed queries and connection issues
- **Transaction Performance**: Database transaction metrics

### Important Labels

- `operation_type`: Database operation type
  - `SELECT`: Read operations
  - `INSERT`: Create operations
  - `UPDATE`: Modify operations
  - `DELETE`: Remove operations
- `table`: Database table name
- `db_name`: Database name
- `query_type`: Query classification (simple, complex, aggregate)

### When to Use

- Database performance optimization
- Identifying slow queries
- Monitoring database health
- Capacity planning

### Key Indicators

- ✅ **Healthy**: Query time < 100ms, Error rate < 1%
- ⚠️ **Warning**: Query time 100-500ms, Error rate 1-5%
- ❌ **Critical**: Query time > 500ms, Error rate > 5%

---

## 6. Shipping Observability Dashboard

### Purpose

Provides deep observability into shipping operations using distributed tracing.

### Key Features

- **Label Purchase Traces**: End-to-end tracing of shipping label creation
- **Trace Lookup**: Search traces by ID or operation ID
- **Correlated Logs**: View logs related to specific traces
- **Operation Patterns**: Find traces matching operation patterns
- **Carrier Performance**: Trace shipping provider interactions

### Key Panels

1. **Label Purchase Traces**: Shows recent shipping label purchases with full trace context
2. **Trace Lookup**: Interactive search for specific traces or operations
3. **Traces by Operation Pattern**: Pattern-based trace discovery
4. **Correlated Logs**: Logs automatically correlated with traces

### Important Trace Attributes

- `service.name`: Always "cybership-server"
- `operation.id`: Unique operation identifier (e.g., "buy-label-team-123-order-456")
- `easypost.carrier_id`: Shipping carrier (usps, fedex, ups)
- `easypost.service_id`: Shipping service type
- `shipping.operation`: Operation type (get_rates, create_shipment, buy_label)
- `shipping.package_type`: Package type being shipped
- `trace_id`: OpenTelemetry trace identifier

### When to Use

- Debugging shipping label failures
- Understanding end-to-end shipping operations
- Correlating logs with specific operations
- Performance analysis of shipping workflows
- Investigating carrier-specific issues

### Navigation Tips

- Use the **trace_id** or **operation_id** variables at the top to filter data
- Click on trace IDs to view detailed span information
- Use the correlated logs panel to see related log entries
- Filter by carrier or service type to focus on specific providers

---

## Dashboard Variables and Filters

### Common Variables

Most dashboards support these variables for filtering:

- `$integration`: Filter by external integration
- `$queue_name`: Filter by specific queue
- `$operation_id`: Filter by operation identifier
- `$trace_id`: Filter by trace identifier
- `$time_range`: Adjust time window for analysis

### Time Range Recommendations

- **Real-time monitoring**: Last 5-15 minutes
- **Troubleshooting**: Last 1-4 hours
- **Performance analysis**: Last 24 hours
- **Trend analysis**: Last 7-30 days

---

## Alerting Guidelines

### Critical Alerts

- Server availability < 95%
- Error rate > 15%
- Queue backlog > 1000 jobs
- Database query time > 1s
- Integration error rate > 20%

### Warning Alerts

- Response time > 2s
- Queue success rate < 95%
- Database connection pool > 80%
- Integration response time > 5s

### Best Practices

1. **Set up alerts** for critical business metrics
2. **Use time-based thresholds** to avoid false positives
3. **Correlate metrics** across dashboards for root cause analysis
4. **Regular review** of dashboard data for optimization opportunities
5. **Document incidents** and update alert thresholds based on learnings

---

## Troubleshooting Guide

### Common Issues and Solutions

#### High Error Rates

1. Check Integration Metrics for external API issues
2. Review Queue Metrics for processing failures
3. Examine Database Metrics for query problems
4. Use Shipping Observability for carrier-specific issues

#### Performance Degradation

1. Monitor Database Metrics for slow queries
2. Check Queue Metrics for bottlenecks
3. Review Integration Metrics for slow external APIs
4. Analyze App Overview for resource constraints

#### Missing Data

1. Verify Prometheus is scraping metrics
2. Check if services are properly instrumented
3. Ensure OpenTelemetry is initialized
4. Validate dashboard queries and time ranges

### Getting Help

- Check the main README.md for system architecture
- Review OpenTelemetry documentation for tracing
- Consult Grafana documentation for dashboard customization
- Use the test endpoints (`/test-otel`, `/otel-status`) for validation
