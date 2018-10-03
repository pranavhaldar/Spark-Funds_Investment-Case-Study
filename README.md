# Spark Funds | Investment Case Study

# Project Brief

You work for Spark Funds, an asset management company. Spark Funds wants to make investments in a few companies. The CEO of Spark Funds wants to understand the global trends in investments so that she can take the investment decisions effectively.

Business and Data Understanding

Spark Funds has two minor constraints for investments:
1. It wants to invest between 5 to 15 million USD per round of investment
2. It wants to invest only in English-speaking countries because of the ease of communication with the companies it would invest in

For analysis, consider a country to be English speaking only if English is one of the official languages in that country

Before getting to specific questions, let’s understand the problem and the data first.

1. What is the strategy?
Spark Funds wants to invest where most other investors are investing. This pattern is often observed among early stage startup investors.

2. Where did we get the data from?
We have taken real investment data from crunchbase.com, so the insights you get may be incredibly useful.
 Company details(companies.txt): A table with basic data of companies
 Funding round details(rounds2.csv)
 Sector Classification(mapping.csv): This file maps the numerous category names in the companies table (such 3D printing, aerospace, agriculture, etc.) to eight broad sector names. 

3. What is Spark Funds’ business objective?
The business objectives and goals of data analysis are pretty straightforward.

Business objective: The objective is to identify the best sectors, countries, and a suitable investment type for making investments. The overall strategy is to invest where others are investing, implying that the best sectors and countries are the ones where most investments are happening.
Goals of data analysis: Your goals are divided into three sub-goals:
Investment type analysis: Understanding investments in the venture, seed/angel, private equity categories, etc. so Spark Funds can decide which type is best suited for its strategy.
Country analysis: Understanding which countries have had the most investments in the past. These will be Spark Funds’ favourites as well.
Sector analysis: Understanding the distribution of investments across the eight main sectors. (Note that we are interested in the eight main sectors provided in the mapping file. The two files — companies and rounds2 — have numerous sub-sector names; hence, you will need to map each sub-sector to its main sector.)
 

4. How do you approach the case study? What are the deliverables?

# Checkpoint 1: Funding Type Analysis
This is the first of the three goals of data analysis – investment type analysis.

The funding types such as seed, venture, angel, etc. depend on the type of the company (startup, corporate, etc.), its stage (early stage startup, funded startup, etc.), the amount of funding (a few million USD to a billion USD), and so on. For example, seed, angel and venture are three common stages of startup funding.

  Seed/angel funding refer to early stage startups whereas venture funding occurs after seed or angel stage/s and involves a relatively higher amount of investment.
  Private equity type investments are associated with much larger companies and involve much higher investments than venture type. Startups which have grown in scale may also receive private equity funding. This means that if a company has reached the venture stage, it would have already passed through the angel or seed stage/s.
  
Spark Funds wants to choose one of these four investment types for each potential investment they will make.

Considering the constraints of Spark Funds, you have to decide one funding type which is most suitable for them.

Calculate the average investment amount for each of the four funding types (venture, angel, seed, and private equity).
Based on the average investment amount calculated above, which investment type do you think is the most suitable for Spark Funds?

# Checkpoint 2: Country Analysis
This is the second goal of analysis — country analysis.

Now that we know the type of investment suited for Spark Funds, let's narrow down the countries.

Spark Funds wants to invest in countries with the highest amount of funding for the chosen investment type. This is a part of its broader strategy to invest where most investments are occurring.

Spark Funds wants to see the top nine countries which have received the highest total funding (across ALL sectors for the chosen investment type). Identify the top three English-speaking countries among them.

Now we also know the three most investment-friendly countries and the most suited funding type for Spark Funds. Let us now focus on finding the best sectors in these countries.

# Checkpoint 3: Sector Analysis 1
This is the third goal of analysis — sector analysis.

When we say sector analysis, we refer to one of the eight main sectors (named main_sector) listed in the mapping file (note that ‘Other’ is one of the eight main sectors). This is to simplify the analysis by grouping the numerous category lists (named ‘category_list’) in the mapping file. For example, in the mapping file, category_lists such as ‘3D’, ‘3D Printing’, ‘3D Technology’, etc. are mapped to the main sector ‘Manufacturing’.

Also, for some companies, the category list is a list of multiple sub-sectors separated by a pipe (vertical bar |). For example, one of the companies’ category_list is Application Platforms|Real Time|Social Network Media.

You discuss with the CEO and come up with the business rule that the first string before the vertical bar will be considered the primary sector. In the example above, ‘Application Platforms’ will be considered the primary sector.

Expected Results: Code for a merged data frame with each primary sector mapped to its main sector.

# Checkpoint 4: Sector Analysis 2
Now we have a data frame with each company’s main sector (main_sector) mapped to it. When we say sector analysis, we refer to one of the eight main sectors.

Also, we know the top three English speaking countries and the most suitable funding type for Spark Funds. Also, the range of funding preferred by Spark Funds is 5 to 15 million USD.

Now, the aim is to find out the most heavily invested main sectors in each of the three countries (for funding type and investments range of 5-15 M USD).

Result Expected 

Based on the analysis of the sectors, which main sectors and countries would you recommend Spark Funds to invest in? Present your conclusions in the presentation. The conclusions are subjective, but it should be based on the basic strategy — invest in sectors where most investments are occurring. 

Also, you have to prepare a short presentation document to present the results of your analysis to the CEO of Spark Funds. This should briefly describe the important results and recommendations.
