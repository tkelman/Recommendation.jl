function test_tf_idf()
    println("-- Testing TF-IDF content-based recommender")

    m = [1  0  1  0  1  1  0  0  0  1
         0  1  1  1  0  0  0  1  0  0
         0  0  0  1  1  1  0  0  0  0
         0  0  1  1  0  0  1  1  0  0
         0  1  0  0  0  0  0  0  1  1
         1  0  0  1  0  0  0  0  0  0
         0  0  0  0  0  0  0  1  0  1
         0  0  1  1  0  0  1  0  0  1
         0  0  0  0  0  1  0  0  1  0
         0  1  0  0  1  0  1  0  0  0
         0  0  1  0  1  0  0  0  1  0
         1  0  0  0  0  1  1  0  0  0
         0  0  1  1  1  0  0  1  0  0
         0  1  1  1  0  0  0  0  1  0
         0  0  0  1  0  1  1  1  0  0
         1  0  0  0  0  1  0  0  1  0
         0  1  1  1  0  0  0  1  0  0
         0  0  0  1  0  0  0  0  1  0
         0  1  1  0  1  0  1  0  0  1
         0  0  1  1  0  0  1  0  1  0]

    tf = sum(m, 1)
    idf = 1 ./ tf

    users = [ 1  -1
             -1   1
              0   0
              0   1
              0   0
              1   0
              0   0
              0   0
              0   0
              0   0
              0   0
              0  -1
              0   0
              0   0
              0   0
              1   0
              0   1
              0   0
             -1   0
              0   0]
    uv1 = sparse(users[:, 1])
    uv2 = sparse(users[:, 2])

    n_doc = size(m, 1)
    docs = [i for i in 1:20]


    # Case: basic
    da = DataAccessor(m)
    set_user_attribute(da, 1, uv1)
    set_user_attribute(da, 2, uv2)

    recommender = TFIDF(da, tf, ones(size(tf))) # do not use IDF
    rec = recommend(recommender, 1, n_doc, docs)
    @test first(rec[2]) == 12
    @test first(rec[3]) == 1
    @test last(rec[2]) == 4 && last(rec[3]) == 4


    # Case: normalized matrix
    m_normalized = m ./ sqrt.(sum(m.^2, 2))
    da = DataAccessor(m_normalized)
    set_user_attribute(da, 1, uv1)
    set_user_attribute(da, 2, uv2)

    recommender = TFIDF(da, tf, ones(size(tf))) # do not use IDF
    rec = recommend(recommender, 1, n_doc, docs)
    @test first(rec[5]) == 1
    @test_approx_eq_eps last(rec[5]) 1.0090 1e-4
    rec = recommend(recommender, 2, n_doc, docs)
    @test first(rec[10]) == 7
    @test_approx_eq_eps last(rec[10]) 0.7444 1e-4
    @test first(rec[11]) == 19
    @test_approx_eq_eps last(rec[11]) 0.4834 1e-4


    # Case: normalized matrix & using IDF
    recommender = TFIDF(da, tf, idf)
    rec = recommend(recommender, 1, n_doc, docs)
    @test first(rec[4]) == 1
    @test_approx_eq_eps last(rec[4]) 0.2476 1e-4
end

test_tf_idf()
