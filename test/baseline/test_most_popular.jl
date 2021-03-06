function test_most_popular()
    println("-- Testing MostPopular recommender")

    da = DataAccessor(sparse([1 2 3; 4 5 0]))
    recommender = MostPopular(da)
    build(recommender)
    @test ranking(recommender, 1, 1) == 2.0
    @test ranking(recommender, 1, 3) == 1.0
end

test_most_popular()
